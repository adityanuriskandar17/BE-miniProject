# app/serializers/insurance_product_serializer.rb

class InsuranceProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name

  has_many :asuransis
end
