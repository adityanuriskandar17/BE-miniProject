# app/services/insurance_product_service.rb
class InsuranceProductService
  def initialize(user, params = {})
    @user = user
    @params = params
  end

  def index
    InsuranceProduct.where(user: @user)
  end

  def show(id)
    InsuranceProduct.find(id)
  end

  def create
    insurance_product = InsuranceProduct.new(@params)
    insurance_product.user = @user
    if insurance_product.save
      { status: :created, insurance_product: insurance_product }
    else
      { status: :unprocessable_entity, errors: insurance_product.errors.full_messages }
    end
  end

  def update(id, update_params)
    insurance_product = InsuranceProduct.find(id)
    if insurance_product.update(update_params)
      { status: :ok, message: 'Insurance product updated successfully' }
    else
      { status: :unprocessable_entity, errors: insurance_product.errors.full_messages }
    end
  end

  def destroy(id)
    insurance_product = InsuranceProduct.find(id)
    if insurance_product.destroy
      { status: :ok, message: 'Insurance product deleted successfully' }
    else
      { status: :unprocessable_entity, errors: insurance_product.errors.full_messages }
    end
  end
end
