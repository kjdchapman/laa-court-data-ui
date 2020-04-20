# frozen_string_literal: true

class FeedbackController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new feedback_params
    if @feedback.valid?
      redirect_to new_feedback_path, notice: 'Your feedback has been submitted'
    else
      render new_feedback_path
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:comment, :email, :rating)
  end
end
  