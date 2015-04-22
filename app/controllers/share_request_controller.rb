class ShareRequestController < ApplicationController
  def new
    @share_request = ShareRequest.new
    @view_title = "Share with"
  end

  def create
  end

  def share
  end

  def notify
  end

  def destroy
  end
end
