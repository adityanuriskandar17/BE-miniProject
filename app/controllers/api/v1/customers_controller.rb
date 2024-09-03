module Api
  module V1
    class CustomersController < ApplicationController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_customer_service, only: [:index, :show, :create, :update, :destroy]
      before_action :set_customer, only: %i[show update destroy]
      before_action :authorize_user!, only: %i[update destroy]

      # GET /api/v1/customers
      def index
        customers = @customer_service.all_customers
        render json: customers
      end

      # GET /api/v1/customers/:id
      def show
        if @customer
          render json: @customer
        else
          render json: { errors: { base: ["Customer not found"] } }, status: :not_found
        end
      end

      # POST /api/v1/customers
      def create
        result = @customer_service.create_customer(customer_params)
        if result[:success]
          render json: result[:customer], status: :created
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/customers/:id
      def update
        result = @customer_service.update_customer(@customer, customer_params)
        if result[:success]
          render json: result[:customer]
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/customers/:id
      def destroy
        result = @customer_service.destroy_customer(@customer)
        if result[:success]
          head :no_content
        else
          render json: result[:errors], status: :unprocessable_entity
        end
      end

      private

      def set_customer_service
        @customer_service = CustomerService.new(current_user)
      end

      def set_customer
        @customer = @customer_service.find_customer(params[:id])
      end

      def authorize_user!
        unless @customer_service.authorize_customer!(@customer)
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      def customer_params
        params.require(:customer).permit(:name, :dob, :address, :phone)
      end
    end
  end
end
