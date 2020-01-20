class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  respond_to :html

  def not_found
    render status: 404
  end

  def unacceptable
    render status: 422
  end

  def internal_error
    render status: 500
  end
end