class AttachmentsController < ApplicationController
  before_action :find_attachment

  respond_to :js
  
  def destroy
    respond_with(@attachment.destroy) if current_user.author_of?(@resource)
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
    @resource =  @attachment.attachable
  end
end
