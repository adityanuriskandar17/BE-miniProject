# app/services/asuransi_service.rb
class AsuransiService
  def initialize(user, params = {})
    @user = user
    @params = params
  end

  def index
    @user.asuransis
  end

  def show(id)
    find_asuransi(id)
  end

  def create
    asuransi = @user.asuransis.new(@params)
    if asuransi.save
      { asuransi: asuransi, status: :created, message: 'Asuransi was successfully created.' }
    else
      { errors: asuransi.errors, status: :unprocessable_entity, message: 'bjirlah' }
    end
  end

  def update(id, update_params)
    asuransi = find_asuransi(id)
    
    if asuransi.update(update_params)
      { asuransi: asuransi, status: :ok, message: 'Asuransi was successfully updated.' }
    else
      { errors: asuransi.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy(id)
    asuransi = find_asuransi(id)
    asuransi.destroy
    { status: :ok, message: 'Asuransi was successfully deleted.' }
  end

  private

  def permitted_params(params)
    allowed_keys = %i[status active_date expire_date customer_id insurance_product_id]
    params.slice(*allowed_keys) # Return only allowed parameters
  end

  def find_asuransi(id)
    @user.asuransis.find_by(id: id) || raise(ActiveRecord::RecordNotFound, 'Asuransi not found')
  end
end