class AttachmentsController < ApplicationController
  before_action :find_attachment

  respond_to :js
  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
    @resource =  @attachment.attachable
  end
end
