class Asuransi
  include Mongoid::Document
  field :status, type: String
  field :active_date, type: Date
  field :expire_date, type: Date

  belongs_to :user
  belongs_to :customer
  belongs_to :insurance_product

  validates :status, inclusion: { in: %w(active inactive) }
  validate :only_one_active_per_customer

  private

  def only_one_active_per_customer
    return unless status == 'active'  # Only check if the status is 'active'
  
    # Check for any other active insurance for the same customer, excluding the current record
    active_insurances = Asuransi.where(customer_id: customer_id, status: 'active').not_in(id: self.id)
    if active_insurances.exists?
      errors.add(:base, 'Customer already has an active insurance.')
    end
  end
  
end