class SubjectsController < ApplicationController
	before_action :set_subject, except: [:index, :new, :create]
  def index
    @view_title = "Listing subjects"
    @subjects = Subject.all
  end

  def edit
    @view_title = "Editing subject"
  end

  def new
    @view_title = "New subject"
    @subject = Subject.new
  end

  def create
    subject_params[:code].upcase!
  	@subject = Subject.new(subject_params)
  	@subject.archived = false

  	respond_to do |format|
      if @subject.save
        format.html { redirect_to subjects_url }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subjects_url }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
  	respond_to do |format|
  		if @subject.archived
  			@subject.update(archived: false)
        @subject.topics.each do |topic|
          topic.update(archived: false)
        end
      else
        @subject.update(archived: true)
        @subject.topics.each do |topic|
          topic.update(archived: true)
        end
  		end
  		format.html { redirect_to subjects_url }
		end
  end

  def destroy
  	if params[:destroy_all]
  		@topics = Topic.where(subject_id: @subject._id)
  		@topics.each do |topic|
  			topic.destroy
  		end
  	end
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

  	# Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:code, :name, :color)
    end
end
