# SubjectsController
class SubjectsController < ApplicationController
	before_action :set_subject, except: [:index, :new, :create]
  before_action :set_errors, only: [:new, :edit]
  before_action :authenticate_user!

  # GET /subjects
  def index
    @view_title = "Listing subjects"
    @subjects = Subject.all
    @subjects = @subjects.sort(archived:1)
  end

  # GET /subjects/edit
  def edit
    @view_title = "Editing subject"
  end

  # GET /subjects/new
  def new
    @url = new_subject_path
    @view_title = "New subject"
    @subject = Subject.new
  end

  # POST /subjects
  def create
    subject_params[:code].upcase!
    @subject = Subject.new(subject_params)
    @subject.archived = false
    @subject.user = User.find_by(username: session[:user_uname])

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_url }
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
        format.html { redirect_to subjects_url }
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
      reset_cache @subject
      
      if @subject.archived
        Subject.unarchive @subject
      else
        Subject.archive @subject
      end
      format.html { redirect_to subjects_url }
    end
  end

  # DELETE /subjects/1
  def destroy
    reset_cache @subject
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_url }
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
      params.require(:subject).permit(:code, :name, :color)
    end
end
