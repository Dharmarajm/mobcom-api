class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.belongs_to :role, foreign_key: true
      t.belongs_to :employee, foreign_key: true

      t.timestamps
    end
  end
end
