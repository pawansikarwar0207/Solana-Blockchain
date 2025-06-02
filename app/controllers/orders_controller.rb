class OrdersController < ApplicationController
  before_action :set_user
  before_action :set_order, only: [:show, :confirm_crypto_payment]

  def index
    @orders = @user.orders.includes(:payment)
  end

  def new
    @products = VerificationProduct.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @user = current_user

    unless @user&.persisted?
      raise "No client organization present!"
    end

    order = @user.orders.create!(order_params)
    # order.update(payment_memo: "ORDER-#{order.id}")
    order.update!(payment_memo: SecureRandom.hex(6)) unless order.payment_memo.present?

    Array(params[:product_ids]).each do |pid|
	    order.order_items.create!(verification_product_id: pid)
	  end

    order.calculate_total!

    redirect_to upload_providers_order_path(order)
  end

  def show
    respond_to do |format|
      format.html # renders show.html.erb by default
      format.json { render json: @order }
    end
  end

  def my_orders
	  @status_filter = params[:status]
	  orders = current_user.orders.includes(:provider_profiles).order(created_at: :desc)
	  orders = orders.where(status: @status_filter) if @status_filter.present?
	  @my_orders = orders.page(params[:page]).per(10)
	end


  def upload_providers
    @order = @user.orders.find(params[:id])
  end

  def submit_providers
	  @order = @user.orders.find(params[:id])

	  if params[:csv_file].present?
	    CsvUploadService.new(@order, params[:csv_file]).call
	  elsif provider_params.values.all?(&:blank?)
	    flash[:alert] = "Please fill out provider details or upload a CSV."
	    redirect_to upload_providers_order_path(@order) and return
	  else
	    @order.provider_profiles.create!(provider_params)
	  end

	  redirect_to checkout_order_path(@order)
	end

  def checkout
    @order = @user.orders.find(params[:id])
    @order.calculate_total!

    total_cents = (@order.total_amount * 100).to_i

    # if total_cents < 50
    #   raise "Order total is not set"
    # end

    # @checkout_session = Stripe::Checkout::Session.create(
    #   payment_method_types: ['card'],
    #   line_items: [{
    #     price_data: {
    #       currency: 'usd',
    #       product_data: {
    #         name: "Verification Order"
    #       },
    #       unit_amount: total_cents
    #     },
    #     quantity: 1
    #   }],
    #   mode: 'payment',
    #   success_url: payment_success_order_url(@order),
    #   cancel_url: cancel_order_order_url(@order)
    # )
  end


  def payment_success
    @order = @user.orders.find(params[:id])
    @order.reload

    respond_to do |format|
      format.html do
        redirect_to @order
      end
      format.json do
        render json: {
          order_id: @order.id,
          status: @order.status,
          paid: @order.status == "paid"
        }
      end
    end
  end


  def cancel_order
    @order = @user.orders.find(params[:id])
    redirect_to @order, alert: 'Payment was canceled.'
  end

  def confirm_crypto_payment
    order = current_user.orders.find(params[:id])

    # Enqueue payment verification job if order still pending
    if order.status == "pending"
      SolanaPaymentVerifierJob.perform_later(order.id)
    end

    # Reload order to get updated status (optional if job is very fast)
    order.reload

    payment_confirmed = (order.status == "paid")

    respond_to do |format|
      format.json do
        render json: {
          order_id: order.id,
          status: order.status,
          payment_confirmed: payment_confirmed,
          message: payment_confirmed ? "Payment received! Status: Paid" : "Still waiting for confirmation. Try again later."
        }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_order
    @order = @user.orders.find_by(id: params[:id])
  end

  def order_params
    params.permit(:id)
  end

  def provider_params
    params.require(:provider_profile).permit(:first_name, :last_name, :npi_number, :license_number, :state)
  end
end