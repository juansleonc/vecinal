module StripeCalls

  def stripe_plans(filter)
    response = Stripe::Plan.all
    response.data.select { |plan| plan.id.start_with? filter }
  rescue => e
    handle_generic_error e
    []
  end

  def save_subscription(params)
    if params[:plan_id].blank?
      errors.add :base, I18n.t('subscriptions.must_select_plan')
      return nil
    end
    if params[:sign_agreement] != '1'
      errors.add :sign_agreement, I18n.t('subscriptions.must_be_accepted')
      return nil
    end
    @stripe_customer = retrieve_stripe_customer
    @stripe_customer ? update_stripe_subscription(params) : create_stripe_subscription(params)
  end

  def retrieve_stripe_customer
    Stripe::Customer.retrieve self.stripe_customer_id if self.stripe_customer_id.present?
  rescue => e
    handle_generic_error e
  end

  def update_stripe_subscription(params)
    subscription = @stripe_customer.subscriptions.first
    return false unless validates_upgrade_downgrade_plan(subscription.plan.id, params[:plan_id])
    subscription.plan = params[:plan_id]
    subscription.source = params[:stripe_card_token] if params[:stripe_card_token].present?
    subscription.save
    self.update stripe_subscription_plan: params[:plan_id], stripe_subscription_status: subscription.status
  rescue => e
    errors.add :base, e.message
    return false
  end

  def create_stripe_subscription(params)
    customer = Stripe::Customer.create(
      :source => params[:stripe_card_token],
      :plan => params[:plan_id],
      :email => self.email
    )
    self.update stripe_customer_id: customer.id, stripe_subscription_plan: params[:plan_id],
      stripe_subscription_status: customer.subscriptions.first.status
  rescue => e
    handle_generic_error e
  end

  def invoices
    past = Stripe::Invoice.all(customer: self.stripe_customer_id)
    upcoming = Stripe::Invoice.upcoming(customer: self.stripe_customer_id)
    {past: past, upcoming: upcoming}
  rescue => e
    handle_generic_error e
    {past: [], upcoming: nil}
  end

  def handle_generic_error(e)
    # Something else happened, show a generic error message (we don't want the user to find out about API/Request/Authentication errors)
    error = Rails.env.production? ? I18n.t('general.generic_error_message') : e.message
    errors.add :base, error
    return nil
  end

  def update_subscription_status
    stripe_customer = retrieve_stripe_customer
    self.update stripe_subscription_status: stripe_customer.subscriptions.first.status if stripe_customer
  end

  def update_stripe_customer_card(stripe_card_token)
    stripe_customer = retrieve_stripe_customer
    stripe_customer.save(source: stripe_card_token) if stripe_customer
  end

end
