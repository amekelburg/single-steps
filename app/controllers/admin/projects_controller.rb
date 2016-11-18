class Admin::ProjectsController < ApplicationController
  
  
  def index
    authorize :admin_page, :show?
  
    @projects = Project.all
  end
  
end
