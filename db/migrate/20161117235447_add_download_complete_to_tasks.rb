class AddDownloadCompleteToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :download_complete, :bool
  end
end
