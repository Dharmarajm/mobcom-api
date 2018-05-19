class CreateMessageLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :message_logs do |t|
      t.integer :from_employee_id
      t.integer :to_employee_id
      t.integer :to_contact_id
      t.string :message

      t.timestamps
    end
  end
end
