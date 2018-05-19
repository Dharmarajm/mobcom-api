class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.float :budget
      t.belongs_to :client, foreign_key: true
      t.boolean :status,default: true
      t.timestamps
    end
  end
end
