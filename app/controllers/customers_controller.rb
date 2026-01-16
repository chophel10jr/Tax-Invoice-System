class CustomersController < ApplicationController
  before_action :set_customer, only: [:edit, :update]

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:cid)
  end
end
