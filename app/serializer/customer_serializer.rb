# app/serializers/customer_serializer.rb
class CustomerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :dob, :address, :phone
  
  has_many :asuransis
end
