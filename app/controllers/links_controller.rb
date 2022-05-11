# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :link, only: :destroy

  authorize_resource

  def destroy
    @link.destroy if current_user&.author_of?(@link.linkable)
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end
