class AddLevelToUserSkills < ActiveRecord::Migration[5.1]
  def change
    add_column :user_skills, :level, :integer
  end
end
