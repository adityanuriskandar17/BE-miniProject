# app/controllers/api/v1/insurance_products_controller.rb

module Api
  module V1
    class InsuranceProductsController < ApplicationController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_insurance_product_service, only: %i[show update destroy]
      before_action :authorize_user!, only: %i[update destroy]

      # GET /insurance_products
      def index
        @insurance_products = InsuranceProductService.new(current_user).index
        serialized_insurance_products = @insurance_products.map { |product| InsuranceProductSerializer.new(product).serializable_hash[:data][:attributes] }
        render json: serialized_insurance_products
      end

      # GET /insurance_products/:id
      def show
        insurance_product = @insurance_product_service.show(params[:id])
        serialized_insurance_product = InsuranceProductSerializer.new(insurance_product).serializable_hash[:data][:attributes]
        render json: serialized_insurance_product
      end

      # POST /insurance_products
      def create
        result = InsuranceProductService.new(current_user, insurance_product_params).create
        render json: result[:insurance_product] || result[:errors], status: result[:status]
      end

      # PATCH/PUT /insurance_products/:id
      def update
        result = @insurance_product_service.update(params[:id], insurance_product_params)
        render json: { message: result[:message] } || result[:errors], status: result[:status]
      end

      # DELETE /insurance_products/:id
      def destroy
        result = @insurance_product_service.destroy(params[:id])
        render json: { message: result[:message] }, status: result[:status]
      end

      private

      def set_insurance_product_service
        @insurance_product_service = InsuranceProductService.new(current_user)
      end

      def authorize_user!
        insurance_product = @insurance_product_service.show(params[:id])
        render json: { error: 'Not authorized' }, status: :forbidden unless insurance_product.user == current_user
      end

      def insurance_product_params
        params.require(:insurance_product).permit(:name)
      end
    end
  end
end
