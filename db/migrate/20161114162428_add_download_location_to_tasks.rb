class AddDownloadLocationToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :download_location, :string
  end
end
