json.extract! employee, :id, :first_name, :last_name, :mobile_number, :email, :employee_id, :designation, :date_of_birth, :street, :pincode, :city, :state, :country, :status, :created_at, :updated_at
json.url employee_url(employee, format: :json)
