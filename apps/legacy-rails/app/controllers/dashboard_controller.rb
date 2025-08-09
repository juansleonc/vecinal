class DashboardController < ApplicationController

  before_action :set_company
  before_action :set_community_and_users, except: :update_report
  before_action :set_dates, except: :update_report
  before_action :set_model, except: :update_report
  before_action :set_chart_attributes, except: [:update_report, :print_report]

  def community
    render 'index'
  end

  def print_report
    @component = 'report_comp'
    render partial: 'report', layout: 'print', locals: { item: params[:item], footer: false }
  end

  def print_chart
    @component = 'line_chart'
    render partial: 'all_line_charts', layout: 'print'
  end

  private

  def set_company
    @company = current_user.my_company
  end

  def set_community_and_users
    if current_user.accountable.class.name ==  'Building'
      @community = current_user.accountable
    end
    @community = params[:community].constantize.find(params[:id]) if params[:community]
    @users = @community ? @community.all_users : @company.administrators_and_residents.ids

  end

  def set_dates
    @start = params[:since] || 12.months.ago
    @step_a = params[:step] ? params[:step].split('.') : ['1', 'month']
    @step = @step_a ? @step_a.first.to_i.send(@step_a.last) : 1.month
    @final = params[:until] || Time.now
    @backward_a = params[:backward] ? params[:backward].split('.') : ['12', 'months']
    @backward = @backward_a ? @backward_a.first.to_i.send(@backward_a.last) : 12.months
  end

  def set_model
    @model = params[:model] || 'User'
  end

  def set_chart_attributes
    @data = @model.constantize.data_chart(@start, @final, @step, @backward, @users)

    @options = {
      since: @start,
      until: @final,
      step: @step_a.join('.'),
      backward: @backward_a.join('.'),
      model: @model
    }
    @options[:community] = @community.class.name if @community
    @options[:id] = @community.id if @community
  end

end