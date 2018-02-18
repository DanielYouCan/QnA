class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @resource =  @attachment.attachable
    @attachment.destroy if current_user.author_of?(@resource)
  end
end
