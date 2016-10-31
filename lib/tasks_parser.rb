require 'csv'
require 'task_definition'
class TasksParser
  #Task_Name,order,icon8,Google Icon,Section,Template_Name,Template_URL,Prereqs,Description
  def self.tasks
    @@tasks ||= self.parse_tasks
  end
  
  def self.parse_tasks
    tasks = {}
    i = 1 # I think the closure_tree starts sorting at 1?
    rows = []
    CSV.read(Rails.root.join('config','task-definitions.csv'), headers: true).each do |row|
      rows << row
    end
    rows.sort{|r1,r2| r1["order"].to_i<=>r2["order"].to_i}.each do |row|
      td = TaskDefinition.new
      td.name = row["Task_Name"]
      td.icon_name= row["icon8"]
      td.preselect =row["Preselect"].to_s.downcase.strip=="yes"
      td.template_name = row["Template_Name"]
      td.template_url = row["Template_URL"]
      td.prereqs = row["Prereqs"]
      td.description = row["Description"]
      
      section_names = row["Section"].split(':')

      parent_section = nil
      # Find the groups separated by ':'
      section_names.each do |s_name|
        s_name = s_name.strip
        if parent_section
          td_section = parent_section.tasks[s_name]
        else
          td_section = tasks[s_name]
        end
        if td_section.nil?
          td_section = TaskDefinition.new
          td_section.tasks = {}
          td_section.name = s_name
          if parent_section
            # For sub-tasks, we order in each grouping
            td_section.sort_order = parent_section.tasks.count
            parent_section.tasks[td_section.name] = td_section
            #td_section.section = parent_section
          else
            # This is a new top-level task
            td_section.sort_order = i
            i+=1
            tasks[td_section.name]=td_section
          end
        end
        parent_section = td_section
      end
      td.section = parent_section
      td.sort_order = row["order"].to_i
      #tasks[td.name]=td
      parent_section.tasks[td.name] = td
    end
    find_icons(tasks)
    return tasks
  end

  def self.find_icons(tasks)
    # Get all the icons to find
    icon_names = []
    tasks.each do |name, task|
      icon_names += get_icon_names(task)
    end
    icon_names = icon_names.flatten.compact.uniq
    file_icon_names = icon_names.collect {|n| n.parameterize.underscore }
    # Find those names in the icon folder
    icon_map ={}
    Dir[Rails.root.join("public/icons8/Color/PNG/24/**/*.png")].each do |fname|
      if fname =~ /\/([^\/]+)-24.png/i
        name = $1
        puts name
        if file_icon_names.include?(name)
          icon_map[name] = fname.gsub(Rails.root.join('public').to_s, '')
        end
      end
    end
    
    tasks.each do |name, task|
      set_icon_path(task, icon_map)
    end
    
  end
  
  def self.get_icon_names(task)
    ([task.icon_name] + (task.tasks || {}).collect {|name, t| get_icon_names(t)}).flatten
  end
  
  def self.set_icon_path(task, icon_map)
    icon_file_name = task.icon_name.to_s.parameterize.underscore 
    task.icon_path = icon_map[icon_file_name]
    (task.tasks || {}).each do |name, t|
      set_icon_path(t, icon_map)
    end
  end
  
end