json.extract! client, :id, :name, :street, :pincode, :city, :state, :country, :created_at, :updated_at
json.url client_url(client, format: :json)
