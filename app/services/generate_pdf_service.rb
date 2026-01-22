class GeneratePdfService < ApplicationService
  attr_accessor :invoice

  def run
    Prawn::Document.new(page_size: "A4", margin: 40) do |pdf|
      register_fonts(pdf)

      header(pdf)
      invoice_details(pdf)
      transactions_table(pdf)
      totals(pdf)
      footer(pdf)

      pdf.render  # Render the PDF
    end
  end

  private

  # Register Noto Serif fonts
  def register_fonts(pdf)
    pdf.font_families.update(
      "NotoSerif" => {
        normal: Rails.root.join("app/assets/fonts/NotoSerif-VariableFont_wdth,wght.ttf").to_s,
        italic: Rails.root.join("app/assets/fonts/NotoSerif-Italic-VariableFont_wdth,wght.ttf").to_s,
        bold: Rails.root.join("app/assets/fonts/NotoSerif-Bold.ttf").to_s
      }
    )
    pdf.font("NotoSerif", style: :normal)  # Set default font for the PDF
  end

  def header(pdf)
    # Logo centered
    logo_path = Rails.root.join("app/assets/images/bnb_logo.png")
    if File.exist?(logo_path)
      pdf.image logo_path, width: 300, position: :center
    end

    pdf.move_down 20

    # Invoice title and TPN
    pdf.font("NotoSerif", style: :bold)
    pdf.fill_color "252D60"
    pdf.text "TAX INVOICE", size: 20, align: :center
    pdf.fill_color "000000"  # reset color for body
    pdf.font("NotoSerif", style: :normal)
    pdf.text "TPN: #{invoice.customer.tax_number || '######'}", size: 12, align: :center
    pdf.move_down 30
  end

  def invoice_details(pdf)
    pdf.font("NotoSerif", style: :normal)

    pdf.table(
      [
        ["Name of Customer:", formatted_name_with_cid],
        ["Address:", invoice.customer.address.to_s.titleize]
      ],
      width: pdf.bounds.width * 0.6,
      position: :center,
      column_widths: [120, pdf.bounds.width * 0.6 - 120], # 🔑 reduced label width
      cell_style: {
        borders: [],
        padding: [2, 2],
        size: 10
      }
    ) do
      column(0).font_style = :bold
    end

    pdf.move_down 15

    pdf.table(
      [
        [
          "<b>Invoice No.:</b> #{invoice.invoice_number.to_s.titleize}",
          "<b>Date:</b> #{invoice.issue_date.strftime('%d-%b-%Y')}"
        ]
      ],
      width: pdf.bounds.width,
      column_widths: [pdf.bounds.width / 2, pdf.bounds.width / 2],
      cell_style: {
        borders: [],
        inline_format: true,
        padding: [2, 2],
        size: 10
      }
    ) do
      column(0).align = :left
      column(1).align = :right
    end

    pdf.move_down 15
  end

  def transactions_table(pdf)
    # Table headers
    table_data = [["Transaction Dt", "Particulars", "Amount", "Comm/Fee", "GST"]]

    # Table rows
    invoice.transactions.each do |transaction|
      table_data << [
        transaction.transaction_date.strftime('%d-%b-%Y'),
        transaction.external_transaction_ref,
        format_currency(transaction.amount),
        format_currency(transaction.tax_amount),
        format_currency(transaction.tax_amount)  # Add GST if exists
      ]
    end

    pdf.table(table_data, header: true, width: pdf.bounds.width) do
      # Header styling
      row(0).font = "NotoSerif"
      row(0).font_style = :bold
      row(0).background_color = '252D60'
      row(0).text_color = 'FFFFFF'

      # Body styling
      rows(1..-1).font = "NotoSerif"
      rows(1..-1).font_style = :normal
      rows(1..-1).text_color = '000000'

      # Alternating row colors
      self.row_colors = ["F6F6F6", "FFFFFF"]

      self.cell_style = { borders: [:bottom], padding: [5,5,5,5], size: 10 }
    end
  end

  def totals(pdf)
    subtotal = invoice.subtotal
    tax_total = invoice.tax_total
    grand_total = invoice.grand_total

    pdf.move_down 5
    pdf.table([
      ["Total", format_currency(subtotal), format_currency(tax_total), format_currency(grand_total)]
    ], width: pdf.bounds.width, cell_style: { borders: [] }) do
      row(0).font = "NotoSerif"
      row(0).font_style = :bold
      row(0).columns(0).align = :left
      row(0).columns(1..3).align = :right
    end
  end

  def footer(pdf)
    pdf.move_down 20
    pdf.font("NotoSerif", style: :normal)
    pdf.text "Thank you for banking with Bhutan National Bank Ltd.", size: 9, align: :center
  end

  def format_currency(amount)
    ActionController::Base.helpers.number_to_currency(amount, unit: "Nu ", precision: 2)
  end

  def formatted_name_with_cid
    name = invoice.customer.name.to_s.titleize
    cid     = invoice.customer.cid.presence

    cid ? "#{name} (#{cid})" : name
  end
end
