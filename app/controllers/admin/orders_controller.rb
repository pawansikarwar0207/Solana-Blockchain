class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def index
    @orders = Order.includes(:provider_profiles).where(status: [:paid, :pending]).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
