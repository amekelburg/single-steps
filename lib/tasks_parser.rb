require 'csv'
class TasksParser
  #Task_Name,icon8,Google Icon,Section,Template_Name,Template_URL,Prereqs,Description
  def self.parse_tasks
    tasks = {}
    i = 0
    CSV.read(Rails.root.join('config','task-definitions.csv'), headers: true).each do |row|
      td = TaskDefinition.new
      td.name = row["Task_Name"]
      td.icon_name= row["icon8"]
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
      td.sort_order = parent_section.tasks.count
      #tasks[td.name]=td
      parent_section.tasks[td.name] = td
    end
    return tasks
  end
  
end