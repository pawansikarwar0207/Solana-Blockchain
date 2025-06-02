class UsersController < ApplicationController
  # before_action :authenticate_user!

  def update_wallet
    current_user.update(solana_wallet: params[:solana_wallet])
    head :ok
  end
end
