class CreateCallLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :call_logs do |t|
      t.integer :from_employee_id
      t.integer :to_employee_id
      t.integer :to_contact_id
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
