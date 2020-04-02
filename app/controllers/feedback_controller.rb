# frozen_string_literal: true

class FeedbackController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  
  def new; end
end
  