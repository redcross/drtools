json.array!(collection) do |resource|
  json.url resource_url(resource, format: :json)
  json.extract! resource, :id, :name, :email, :gap, :member_number, :vc_id
  json.extract! resource, :home_phone, :work_phone
  json.extract! resource, :primary_phone, :primary_email
end