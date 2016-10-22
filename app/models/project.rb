class Project < ApplicationRecord
  # Remove extra whitespace so find-by-name-and-pin can be cleaner
  
  before_validation :clean_name, :clean_pin
  after_create :init_tasks
  
  has_many :tasks
  
  validates :name, uniqueness: { case_sensitive: false}
  
  
  def self.find_by_name_nad_pin(name, pin)
    self.where(name: name.to_s.strip, pin: pin.to_s.strip.downcase).first
  end
  
  
  def init_tasks!
    init_tasks
  end
  
  private
  def clean_name
    self.name = self.name.strip
  end
  def clean_pin
    self.pin = self.pin.strip.downcase
  end
  
  def init_tasks
    tasks.delete_all
    task_groups = TasksParser.parse_tasks
    task_groups.each do |key, task_def|
      t = add_task(task_def)
    end
  end
  
  def populate_prereqs
  end

  def add_task(task_def)
    t = Task.new(task_def.model_attributes)
    self.tasks << t
    t.save
    (task_def.tasks || {}).each do |key, sub_task_def|
      sub_task = add_task(sub_task_def)
      sub_task.parent_id = t.id
      sub_task.save
    end
    return t
  end
  
end
