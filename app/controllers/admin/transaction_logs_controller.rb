# app/controllers/admin/transaction_logs_controller.rb
class Admin::TransactionLogsController < ApplicationController
  def index
    @transaction_logs = TransactionLog
          .select('DISTINCT ON (solana_tx) *')
          .order(:solana_tx, created_at: :desc)
          .paginate(page: params[:page], per_page: params[:per_page] || 10)
  end
end
