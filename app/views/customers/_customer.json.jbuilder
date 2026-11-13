json.extract! customer, :id, :employee_id, :name, :age, :created_at, :updated_at
json.url customer_url(customer, format: :json)
