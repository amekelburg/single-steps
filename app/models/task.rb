class Task < ApplicationRecord
  has_closure_tree order: 'sort_order'
  
  enum state: [:excluded, :inprogress, :complete]
  
  belongs_to :project
  
  serialize :prereqs, Array
  
  def has_template?
    !template_url.blank?
  end
  
  def has_downloadable_template?
    !template_download_url.blank?
  end
  
  def template_download_url
    if template_id
      "https://docs.google.com/spreadsheets/d/#{template_id}/export?format=xlsx"
    else
      nil
    end
  end
  
  def template_id
    if template_url.to_s =~ /id=(.+)$/
      $1
    else
      nil
    end
  end
  
  def prereq_tasks
    self.project.tasks.where(name: prereqs)
  end
  
  def status
    if excluded?
      'excluded'
    elsif complete?
      'complete'
    else
      'inprogress'
    end
  end
  
  def status_label
    s = status
    s == 'inprogress' ? 'in progress' : s
  end
  
  def completable?
    self.included? && !self.children.any?
  end
  
  def included?
    !excluded?
  end
  
  def complete?
    if children.any?
      children.all? {|c| c.complete? || c.excluded? }
    else
      super
    end
  end
  
  def excluded?
    if children.any?
      children.all?(&:excluded?)
    else
      super
    end
  end
  
end