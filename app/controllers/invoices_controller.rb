class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :edit, :update, :download_pdf]

  def index
    @invoices = Invoice
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 1)
  end

  def new; end

  def show
    @customer = @invoice.customer
    @transactions = @invoice.transactions.order(:transaction_date)
  end
  
  def edit
    @customer = @invoice.customer
    @transactions = @invoice.transactions.order(:transaction_date)
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to edit_invoice_path(@invoice), notice: "Invoice updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    rows = FetchTransactionDetailService.new(
      transactions: params['transaction_reference_numbers']
    ).run

    result = InvoiceCreationService.new(rows: rows, user: current_user).run

    flash[:notice] = "Invoice created successfully! Invoice number: #{result[:invoice_number]}"
    redirect_to invoice_path(id: result[:invoice_number])

  rescue StandardError => e
    redirect_to root_path, alert: "Invoice creation failed: #{e.message}"
  end

  def download_pdf
    pdf = GeneratePdfService.new(invoice: @invoice).run

    send_data pdf.render,
              filename: "invoice_#{@invoice.invoice_number}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:issue_date, :status)
  end
end
