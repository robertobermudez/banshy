class CreateVideoFileTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists? :video_files
      create_table :video_files do |table|
        table.string :name
        table.string :path
        table.string :duration
        table.timestamps
      end
    end
  end

  def down
    drop_table(:video_files) if ActiveRecord::Base.connection.table_exists?(:video_files)
  end
end
