class Admin::VerificationProductsController < ApplicationController

  def new
    @verification_product = VerificationProduct.new
  end

  def create
    @verification_product = VerificationProduct.new(verification_product_params)
    if @verification_product.save
      redirect_to verification_products_path, notice: 'Product has been saved.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def verification_product_params
    params.require(:verification_product).permit(:name, :description, :price)
  end
end

