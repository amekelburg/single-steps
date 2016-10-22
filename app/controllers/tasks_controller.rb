class TasksController < ApplicationController
  
  def show
    @task = Task.find(params[:id])
    @project = @task.project
  end
  
  def update
    @task = Task.find(params[:id])
    if params[:task]["task_#{@task.id}_included"]=="1"
      @task.inprogress!
      #redirect_to select_tasks_project_path(@task.project)
    elsif params[:task]["task_#{@task.id}_included"]=="0"
      @task.excluded!
      #redirect_to select_tasks_project_path(@task.project)
    elsif params[:task]["task_#{@task.id}_complete"]=="1"
      @task.complete!
      #redirect_to project_task_path(@task.project, @task.root)
    elsif params[:task]["task_#{@task.id}_complete"]=="0"
      @task.inprogress!
      #redirect_to project_task_path(@task.project, @task.root)
    end
    redirect_to :back
  end
end
