class Task < ApplicationRecord
  has_closure_tree order: 'sort_order'
  
  enum state: [:excluded, :inprogress, :complete]
  
  belongs_to :project
  
  def status
    if excluded?
      'excluded'
    elsif complete?
      'complete'
    else
      'inprogress'
    end
  end
  
  def included?
    !excluded?
  end
  
  def excluded?
    if children.any?
      children.all?(&:excluded?)
    else
      super
    end
  end
  
end
