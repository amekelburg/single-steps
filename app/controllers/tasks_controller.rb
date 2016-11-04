class TasksController < ApplicationController
  
  def show
    @task = Task.find(params[:id])
    @project = @task.project
  end
  
  def update
    task = Task.find(params[:id])
    update_type = nil
    if params[:task]["task_#{task.id}_included"]=="1"
      update_type=:inclusion
      task.inprogress!
    elsif params[:task]["task_#{task.id}_included"]=="0"
      update_type=:inclusion
      task.excluded!
    elsif params[:task]["task_#{task.id}_complete"]=="1"
      update_type=:completion
      task.complete!
    elsif params[:task]["task_#{task.id}_complete"]=="0"
      update_type=:completion
      task.inprogress!
    end
    respond_to do |format|
      format.html { 
        @task = task
        redirect_back(fallback_location: project_path(@task.project))
      }
      format.js { 
        if update_type == :inclusion
          @task = task
          render 'include_task_checkbox'
        else
          @task = Task.find(params[:parent_task])
          @project = @task.project
          render 'task_checkbox'
        end
      }
    end
  end
  
  def include
    selected_task = Task.find(params[:id])
    selected_task.inprogress!
    @task = Task.find(params[:parent_task])
    @project = @task.project
    respond_to do |format|
      format.js {
        render 'task_checkbox'
      }
    end
  end
  def exclude
    selected_task = Task.find(params[:id])
    selected_task.excluded!
    @task = Task.find(params[:parent_task])
    @project = @task.project
    respond_to do |format|
      format.js {
        render 'task_checkbox'
      }
    end
  end
  
end
