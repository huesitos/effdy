class ShareRequestController < ApplicationController
  def new
    @share_request = ShareRequest.new
    @view_title = "Share with"
    @url = share_requests_path(params[:type],params[:oid])
  end

  def create
    @view_title = "Share with"
    @share_request = ShareRequest.new(type: params[:type], oid: params[:oid], sender: session[:user_uname], recipient: params[:share_request][:recipient])

    user=User.find_by(username: params[:share_request][:recipient])

    respond_to do |format|
      if user
        if @share_request.save
          if params[:type] == 'topic'
            format.html { redirect_to Topic.find(params[:oid]) }
          else 
            format.html { redirect_to Subject.find(params[:oid]) }
            end
        else
          format.html { render :new }
          format.json { render json: @share_request.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to share_request_new_path, notice: "username not found" }
      end
    end
  end

  def share
  end

  def notify
  end

  def destroy
  end
end
