# SubjectsController
class SubjectsController < ApplicationController
  before_action :set_subject, except: [:index, :new, :create]
  before_action :set_errors, only: [:new, :edit]
  before_action :authenticate_user!

  # GET /subjects
  def index
    @view_title = t(".subjects")
    @user_id = session[:user_id]

    @total = Subject.count.to_i
    @subjects = Subject.where(user_id: session[:user_id])    
    col_subj_ids = SubjectConfig.where(user_id: session[:user_id]).pluck(:subject_id)
    @collaborating_subjects = Subject.where(
      :_id => { "$in" => col_subj_ids}, 
      :user_id => { "$ne" => session[:user_id]}
      )
  end

  # Get /subject/:id
  def show
    @view_title = @subject.name
    topic_ids = TopicConfig.where(user_id: session[:user_id]).sort(reviewing: -1, archived: 1).pluck(:topic_id)
    @topics = Topic.where(_id: {"$in" => topic_ids}, subject_id: @subject.id)

    @subject_config = SubjectConfig.find_by(subject_id: @subject.id)
    @total = @subject.topics.count.to_i

    topic_ids = TopicConfig.from_user(session[:user_id]).pluck(:topic_id)
    topics = Topic.where(_id: {"$in" => topic_ids}, subject_id: @subject.id)

    @subject_show = true
  end

  # GET /subjects/edit
  def edit
    @view_title = t('.edit_subject')
    @subject_config = @subject.subject_configs.find_by(user_id: session[:user_id])
    @edit = true
  end

  # GET /subjects/new
  def new
    @url = new_subject_path
    @view_title = t('.new_subject')
    @subject = Subject.new
    @new = true
  end

  # POST /subjects
  def create
    user = User.find(session[:user_id])

    subject_params[:code].upcase!
    @subject = Subject.new(subject_params)
    subject_config = SubjectConfig.new(
      color: params[:subject_color],
      user_id: session[:user_id])
    @subject.user = user

    respond_to do |format|
      if @subject.save && subject_config.save
        @subject.subject_configs << subject_config

        format.html {
          flash[:success] = t('.created')

          redirect_to subjects_url
        }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { redirect_to new_subject_path(errors: @subject.errors.full_messages.each.to_a) }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        subject_config = @subject.subject_configs.find_by(user_id: session[:user_id])
        subject_config.update(color: params[:subject_color])

        format.html {
          flash[:success] = t('.updated')

          redirect_to subject_path(@subject)
        }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { redirect_to edit_subject_path(errors: @subject.errors.full_messages.each.to_a) }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /subjects/archive
  # Archives subject with all its topics.
  def archive
    respond_to do |format|
      subject_config = @subject.subject_configs.find_by(user_id: session[:user_id])

      if subject_config.archived
        subject_config.unarchive
      else
        subject_config.archive
      end
      if params[:back]
        format.html { redirect_to params[:back] }
      else
        format.html { redirect_to subjects_url }
      end
    end
  end

  # DELETE /subjects/1
  def destroy
    reset_cache @subject

    subject_config = @subject.subject_configs.find_by(user_id: session[:user_id])
    subject_config.unarchive
    
    if params[:delete_all]
      @subject.destroy_topics
    end
    @subject.destroy

    respond_to do |format|
      format.html {
        flash[:success] = t('.destroyed')

        redirect_to subjects_url
      }
      format.json { head :no_content }
    end
  end

  private
  	# Use callbacks to share common setup or constraints between actions.
  	def set_subject
      if params[:id]
        @subject = Subject.find(params[:id])
      else
        @subject = Subject.find(params[:subject_id])
      end
  	end

    # If the subject code in cache is the same as the subject to be archived or
    # destroyed, reset subject code to 'all'
    def reset_cache(subject)
      if Rails.cache.read('subject') and Rails.cache.read('subject') == subject.code
        Rails.cache.write('subject', 'all')
      end
    end

    # Pack errors in a variable to be shown in the form
    def set_errors
      @errors = params[:errors] if params[:errors]
    end

  	# Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:code, :name)
    end
end
