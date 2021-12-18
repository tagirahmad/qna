# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    @result = Search.call(params[:query], params[:scope])
  end
end
