class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :generate_pdf]
  before_action :authorize_pdf_generation, only: [:generate_pdf]

  def index
    @invoices = Invoice
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)
  end

  def new; end

  def show
    @customer = @invoice.customer
    @transactions = @invoice.transactions.order(:transaction_date)
  end

  def create
    rows = FetchTransactionDetailService.new(
      transactions: params['transaction_reference_numbers']
    ).run

    result = InvoiceCreationService.new(rows: rows, user: current_user).run

    flash[:notice] = "Invoice created successfully! Invoice number: #{result[:invoice_number]}"
    redirect_to invoice_path(id: result[:invoice_id])

  rescue StandardError => e
    redirect_to root_path, alert: "Invoice creation failed: #{e.message}"
  end

  def generate_pdf
    pdf = GeneratePdfService.new(invoice: @invoice).run

    @invoice.update!(status: :issued)

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

  def authorize_pdf_generation
    unless current_user.admin? || @invoice.customer == current_user
      redirect_to invoices_path, alert: "You are not authorized to download this invoice."
    end
  end
end
