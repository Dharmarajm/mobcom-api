class CreateTimeSheets < ActiveRecord::Migration[5.1]
  def change
    create_table :time_sheets do |t|
      t.date :date
      t.float :hours
      t.belongs_to :project, foreign_key: true
      t.belongs_to :employee, foreign_key: true
      t.boolean :approval_status
      t.float :revised_hours

      t.timestamps
    end
  end
end
