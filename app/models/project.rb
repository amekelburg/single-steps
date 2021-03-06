require 'tasks_parser'
require 'task_definition'
class Project < ApplicationRecord
  # Remove extra whitespace so find-by-name-and-pin can be cleaner
  extend FriendlyId
  friendly_id :id_and_name, use: :slugged
  def id_and_name
    "#{id} #{name}"
  end

  after_commit :update_slug, on: :create

  before_validation :clean_name, :clean_pin
  after_create :init_tasks
  
  has_many :tasks, dependent: :destroy
  has_and_belongs_to_many :users
  
  
  validates :name, uniqueness: { case_sensitive: false}
  validates_presence_of :name, :pin, :email
  
  
  def self.find_by_name_and_pin(name, pin)
    self.where(pin: pin.to_s.strip.upcase).where("lower(name) = ?", name.to_s.strip.downcase).first
  end
  
  
  def init_tasks!
    init_tasks
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
  
  def children
    tasks.roots
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
  
  
  private
  def clean_name
    self.name = self.name.to_s.strip
  end
  def clean_pin
    self.pin = self.pin.to_s.strip.upcase
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

  def update_slug
    unless slug.include? self.id.to_s
      self.slug = nil
      self.save
    end
  end
  
  
end
