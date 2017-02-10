class AddCreatorIdToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :creator_id, :integer
  end
end
