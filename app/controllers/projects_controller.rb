class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :unassign_user, :select_tasks, :all_tasks]
  # GET /projects
  # GET /projects.json
  def index
    if current_user
      @projects = current_user.projects
    else
      @projects = []
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def find
    name = params[:name]
    pin = params[:pin]
    @project = Project.find_by_name_and_pin(name, pin)
    if @project
      flash[:notice] = "Found project #{name}"
      if current_user
        current_user.add_project(@project)
      end
      redirect_to project_path(@project)
    else
      flash[:error] = "Could not find project '#{name}' with pin '#{pin}'"
      redirect_to projects_path
    end
  end
  
  def show
    raise ActionController::RoutingError.new('Project Not Found') if @project.nil?
    @tasks = @project.tasks.roots
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end
  
  def select_tasks
    @tasks = @project.tasks.roots
  end
  
  def all_tasks
    @task = @project #override the concept of the "parent" task for nested groups
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        if current_user
          current_user.add_project(@project)
        end
        format.html { redirect_to select_tasks_project_path(@project), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def unassign_user
    if current_user
      current_user.remove_project(@project)
    end
    redirect_to projects_path
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :pin)
    end
end
