json.extract! contact, :id, :name, :email, :mobile_number, :telephone_number, :client_id, :designation, :created_at, :updated_at
json.url contact_url(contact, format: :json)
