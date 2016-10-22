class User < ApplicationRecord
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  
  has_and_belongs_to_many :projects

  def set_default_role
    self.role ||= :user
  end
  
  def add_project(project)
    unless self.projects.include?(project)
      self.projects << project
      self.save
    end
  end
  
  def remove_project(project)
    self.projects.delete(project)
    self.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
