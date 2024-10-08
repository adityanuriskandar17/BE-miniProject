# app/controllers/api/v1/asuransis_controller.rb
module Api
  module V1
    class AsuransisController < ApplicationController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_asuransi_service, only: %i[show update destroy]
      before_action :authorize_user!, only: %i[update destroy]

      # GET /api/v1/asuransis
      def index
        @asuransis = AsuransiService.new(current_user).index
        serialized_asuransis = @asuransis.map { |asuransi| AsuransiSerializer.new(asuransi).serializable_hash[:data][:attributes] }
        render json: serialized_asuransis
      end

      # GET /api/v1/asuransis/:id
      def show
        asuransi = @asuransi_service.show(params[:id])
        serialized_asuransi = AsuransiSerializer.new(asuransi).serializable_hash[:data][:attributes]
        render json: serialized_asuransi
      end

      # POST /api/v1/asuransis
      def create
        result = AsuransiService.new(current_user, asuransi_params).create
        render json: { message: result[:message] }, status: result[:status]
      end

      # PATCH/PUT /api/v1/asuransis/:id
      def update
        result = @asuransi_service.update(params[:id], asuransi_params)  # Pass id and asuransi_params to service
        if result[:status] == :ok
          render json: { message: result[:message] }, status: :ok
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/asuransis/:id
      def destroy
        result = @asuransi_service.destroy(params[:id])
        render json: { message: result[:message] }, status: result[:status]
      end

      private

      def set_asuransi_service
        @asuransi_service = AsuransiService.new(current_user)
      end

      def authorize_user!
        asuransi = @asuransi_service.show(params[:id])
        render json: { error: 'Not authorized' }, status: :forbidden unless asuransi.user == current_user
      end

      def asuransi_params
        params.require(:asuransi).permit(:status, :active_date, :expire_date, :customer_id, :insurance_product_id)
      end
    end
  end
end