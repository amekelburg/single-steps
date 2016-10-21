class TasksController < ApplicationController
  def update
    @task = Task.find(params[:id])
    if params[:task][:included]=="1"
      @task.inprogress!
    elsif params[:task][:included]=="0"
      @task.excluded!
    end
    redirect_to select_tasks_project_path(@task.project)
  end
end
