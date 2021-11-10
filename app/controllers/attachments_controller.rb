# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    if current_user.author_of?(attachment.record)
      attachment.purge
      flash[:alert] = "#{attachment.filename} was successfully deleted!"
    else
      flash[:error] = 'Not enough permission: for delete'
    end
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
