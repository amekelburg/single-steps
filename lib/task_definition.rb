class TaskDefinition
  #Task_Name,icon8,Google Icon,Section,Template_Name,Template_URL,Prereqs,Description
  # Color/PNG/24/Editing/drafting_compass
  
  attr_accessor :name, :icon_name, :icon_path, :section, :template_name, :template_url, :prereqs, :description, :tasks, :sort_order
  
  
  def model_attributes
    attribs = {}
    [:name, :icon_name, :icon_path, :section, :template_name, :template_url, :prereqs, :description, :sort_order].each do |attrib|
      attribs[attrib] = self.send(attrib)
    end
    return attribs
  end
  
end