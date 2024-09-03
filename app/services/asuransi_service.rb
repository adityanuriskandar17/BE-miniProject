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
      { errors: asuransi.errors, status: :unprocessable_entity }
    end
  end

  def update(id)
    asuransi = find_asuransi(id)
    if asuransi.update(@params)
      { asuransi: asuransi, status: :ok, message: 'Asuransi was successfully updated.' }
    else
      { errors: asuransi.errors, status: :unprocessable_entity }
    end
  end

  def destroy(id)
    asuransi = find_asuransi(id)
    asuransi.destroy
    { status: :ok, message: 'Asuransi was successfully deleted.' }
  end

  private

  def find_asuransi(id)
    asuransi = @user.asuransis.find_by(id: id)
    raise ActiveRecord::RecordNotFound, 'asuransi not found' unless asuransi
    asuransi
  end
end