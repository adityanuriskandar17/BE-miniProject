class Customer
  include Mongoid::Document
  field :name, type: String
  field :dob, type: Date
  field :address, type: String
  field :phone, type: String

  validates :phone, presence: true, uniqueness: { scope: :user_id, message: "already exists for this user" }
  validates :name, :dob, :address, presence: true
  validates :user, presence: true  # Ensure a customer must belong to a user

  belongs_to :user
  has_many :asuransis

  after_save :update_customer_cache
  after_destroy :remove_customer_cache

  private

  def update_customer_cache
    Rails.logger.info "Updating Redis cache for customer: #{self.id}"
    $redis.set("customer:#{self.id}", self.to_json)
  end 

  def remove_customer_cache
    Rails.logger.info "Removing Redis cache for customer: #{self.id}"
    $redis.del("customer:#{self.id}")
  end
end