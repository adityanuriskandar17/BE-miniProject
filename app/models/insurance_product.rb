class InsuranceProduct
  include Mongoid::Document
  field :name, type: String

  validates :name, presence: true, uniqueness: { scope: :user_id, message: "already exists for this insurance product" }

  belongs_to :user
  has_many :asuransis
end