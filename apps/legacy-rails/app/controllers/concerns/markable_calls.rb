module MarkableCalls
  extend ActiveSupport::Concern

  included do
  end

  def toggle_mark_for(markable, label)
    @markable = markable
    @markable.toggle_mark current_user, label
    render "marks/toggle_#{label}"
  end

end
