class ShareRequestController < ApplicationController
  before_action :set_object,  only: [:new]

  def new
    @share_request = ShareRequest.new
    @view_title = "Share with"
    @users = User.where(:_id => { "$ne" => session[:user_id]}).pluck(:username, :_id)
    @url = share_requests_path(params[:object_type],params[:oid], params[:name])

    if params[:object_type] == "topic"
      topic = Topic.find(params[:oid])
      user_ids = topic.topic_configs.pluck(:user_id)
      @owner = topic.user.id
    else
      subject = Subject.find(params[:oid])
      user_ids = subject.subject_configs.pluck(:user_id)
      @owner = subject.user.id
    end
    
    @collaborators = User.where(:_id => { "$in" => user_ids, "$ne" => session[:user_id] })
  end

  def create
    @view_title = "Share with"
    @users = User.where(:_id => { "$ne" => session[:user_id]}).pluck(:username, :_id)
    sender = User.find(session[:user_id])
    params[:commit] == "Send copy" ? kind = "share" : kind = "collaborate"

    @share_request = ShareRequest.new(
      kind: kind, 
      object_type: params[:object_type], 
      name: params[:name], 
      oid: params[:oid], 
      sender_id: sender.id, 
      sender_uname: sender.username, 
      recipient: params[:share_request][:recipient])

    user=User.find(params[:share_request][:recipient])

    if session[:user_id] == params[:share_request][:recipient]
      respond_to do |format|
        flash[:error] = "Can't share with yourself."
        redirect_to { share_request_new_path }
      end
    end

    respond_to do |format|
      if user
        if @share_request.save
          if params[:object_type] == 'topic'
            format.html { redirect_to Topic.find(params[:oid]) }
          else
            format.html { redirect_to Subject.find(params[:oid]) }
            end
        else
          format.html { render :new }
          format.json { render json: @share_request.errors, status: :unprocessable_entity }
        end
      else
        flash[:error] = "Username not found."
        format.html { redirect_to share_request_new_path }
      end
    end
  end

  def share
    share_request = ShareRequest.find(params[:id])
     
    if share_request.object_type == "topic"
      topic = Topic.find(share_request[:oid])
      if share_request.kind == "share"
        topic.share(share_request.recipient, nil)
      else
        topic.add_collaborator(share_request.recipient)
      end
    else
      subject = Subject.find(share_request[:oid])
      if share_request.kind == "share"
        subject.share(share_request.recipient)
      else
        subject.add_collaborator(share_request.recipient)
      end
    end
    share_request.destroy

    respond_to do |format|
     format.html { redirect_to share_request_notify_path }
    end
  end

  def remove_collaborator
    if params[:object_type] == "topic"
      topic = Topic.find(params[:oid])
      topic.remove_collaborator(params[:user_id])

      respond_to do |format|
       format.html { redirect_to share_request_new_path(
        'topic', 
        params[:oid],
        topic.title) }
      end
    else
      subject = Subject.find(params[:oid])
      subject.remove_collaborator(params[:user_id])

      respond_to do |format|
       format.html { redirect_to share_request_new_path(
        'subject', 
        params[:oid],
        subject.name) }
      end
    end
  end

  def notify
    @view_title = "Notifications"
    @share_requests = ShareRequest.where(recipient: session[:user_id])
  end

  def destroy
    share_request = ShareRequest.find(params[:id])
    share_request.destroy

    respond_to do |format|
      format.html { redirect_to share_request_notify_path }
    end
  end

  private

    def set_object
      if params[:object_type] == "topic"
        @topic = Topic.find(params[:oid])
      else
        @subject = Subject.find(params[:oid])
      end
    end
end
