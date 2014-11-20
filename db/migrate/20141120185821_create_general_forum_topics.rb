class CreateGeneralForumTopics < ActiveRecord::Migration
  def change
    create_table :general_forum_topics do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
