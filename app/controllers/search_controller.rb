# frozen_string_literal: true

class SearchController < ApplicationController
  protect_from_forgery with: :exception

  before_action :set_search_args
  after_action :set_back_page_path, only: :new

  def new
    @search_option = search_params[:search_option] || helpers.search_options.first
  end

  def create
    redirect_to action: :index, filter: search_params[:search_option]
  end

  def index
    @results = Search.new(query: @query, filter: @filter).call if @filter && @query
    set_search_options
  end

  private

  def set_search_args
    @query = search_params[:query]
    @filter = search_params[:filter] || 'case_number'
  end

  def set_search_options
    case @filter
    when 'defendant'
      @label = 'Find a defendant'
      @hint = 'Search by MAAT number or defendant name'
    else
      @label = 'Find a case'
      @hint = 'Search by case number'
    end
  end

  def search_params
    params.permit(:authenticity_token, :button, :search_option, :query, :filter)
  end
end
