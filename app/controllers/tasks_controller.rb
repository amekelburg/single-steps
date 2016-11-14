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
          set_task_and_project_from_parent
          if @task.is_a?(Project)
            render 'all_tasks'
          else
            render 'task_checkbox'
          end
        end
      }
    end
  end
  
  def include
    selected_task = Task.find(params[:id])
    selected_task.inprogress!
    set_task_and_project_from_parent
    respond_to do |format|
      format.js {
        if @task.is_a?(Project)
          render 'all_tasks'
        else
          render 'task_checkbox'
        end
      }
    end
  end
  def exclude
    selected_task = Task.find(params[:id])
    selected_task.excluded!
    set_task_and_project_from_parent
    respond_to do |format|
      format.js {
        if @task.is_a?(Project)
          render 'all_tasks'
        else
          render 'task_checkbox'
        end
      }
    end
  end
  
  private
  def set_task_and_project_from_parent
    @task = Task.find_by_id(params[:parent_task])
    if @task
      @project = @task.project
    else
      @project = Project.find_by_id(params[:parent_task])
      @task = @project
    end    
  end
  
end
