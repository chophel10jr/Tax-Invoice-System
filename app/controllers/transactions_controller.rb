class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: [:edit, :update]
  before_action :authorize_transaction_modification!

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction updated successfully."
    else
      flash.now[:alert] = @transaction.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description)
  end

  def authorize_transaction_modification!
    invoice = @transaction.invoice

    unless current_user&.can_modify_transactions?(invoice)
      redirect_to invoice_path(invoice),
        alert: "This invoice is issued or you are not authorized."
    end
  end
end
