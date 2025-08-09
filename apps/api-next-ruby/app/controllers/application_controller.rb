class ApplicationController < ActionController::API
  include ExceptionHandler
  include Authentication

  def render_success(payload = {}, status: :ok)
    render json: payload, status: status
  end
end
