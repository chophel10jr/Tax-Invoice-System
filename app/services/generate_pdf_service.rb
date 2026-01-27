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

      pdf.render
    end
  end

  private

  def column_widths(pdf)
    Array.new(5, pdf.bounds.width / 5.0)
  end

  def register_fonts(pdf)
    pdf.font_families.update(
      "NotoSerif" => {
        normal: Rails.root.join("app/assets/fonts/NotoSerif-VariableFont_wdth,wght.ttf").to_s,
        italic: Rails.root.join("app/assets/fonts/NotoSerif-Italic-VariableFont_wdth,wght.ttf").to_s,
        bold: Rails.root.join("app/assets/fonts/NotoSerif-Bold.ttf").to_s
      }
    )
    pdf.font("NotoSerif")
  end

  def header(pdf)
    logo_path = Rails.root.join("app/assets/images/bnb_logo.png")
    pdf.image logo_path, width: 300, position: :center if File.exist?(logo_path)

    pdf.move_down 20
    pdf.font("NotoSerif", style: :bold)
    pdf.fill_color "252D60"
    pdf.text "TAX INVOICE", size: 20, align: :center

    pdf.fill_color "000000"
    pdf.font("NotoSerif", style: :normal)
    pdf.text "TPN: #{invoice.customer.tax_number || '######'}", size: 12, align: :center
    pdf.move_down 30
  end

  def invoice_details(pdf)
    pdf.table(
      [
        ["Name of Customer:", formatted_name_with_cid],
        ["Address:", invoice.customer.address.to_s.titleize]
      ],
      width: pdf.bounds.width * 0.6,
      position: :center,
      column_widths: [120, pdf.bounds.width * 0.6 - 120],
      cell_style: { borders: [], padding: [2, 2], size: 10 }
    ) do
      column(0).font_style = :bold
    end

    pdf.move_down 15

    pdf.table(
      [[
        "<b>Invoice No.:</b> #{invoice.invoice_number}",
        "<b>Date:</b> #{invoice.issue_date.strftime('%d-%b-%Y')}"
      ]],
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
    table_data = [
      ["Transaction Date", "Particulars", "Amount", "Comm/Fee", "GST", "Total"]
    ]

    invoice.transactions.each do |t|
      comm_fee = t.tax_amount.to_f / 0.05
      table_data << [
        t.transaction_date.strftime('%d-%b-%Y'),
        t.description,
        format_currency(t.amount),
        format_currency(comm_fee),
        format_currency(t.tax_amount),
        format_currency(t.amount.to_f + t.tax_amount.to_f)
      ]
    end

    pdf.table(
      table_data,
      header: true,
      width: pdf.bounds.width,
      column_widths: Array.new(6, pdf.bounds.width / 6.0)
    ) do
      row(0).font_style = :bold
      row(0).background_color = "252D60"
      row(0).text_color = "FFFFFF"

      self.row_colors = ["F6F6F6", "FFFFFF"]
      self.cell_style = {
        borders: [:bottom],
        padding: [5, 5],
        size: 10
      }

      columns(2..5).align = :right
    end
  end

  def totals(pdf)
    pdf.move_down 5

    total_comm_fee = invoice.transactions.sum { |t| t.tax_amount.to_f / 0.05 }

    total_amount   = invoice.transactions.sum { |t| t.amount.to_f }

    pdf.table(
      [[
        { content: "Total", colspan: 2 },
        format_currency(total_amount),
        format_currency(total_comm_fee),
        format_currency(invoice.tax_total),
        format_currency(invoice.grand_total)
      ]],
      width: pdf.bounds.width,
      column_widths: Array.new(6, pdf.bounds.width / 6.0),
      cell_style: { borders: [], padding: [5, 5] }
    ) do
      row(0).font_style = :bold
      row(0).columns(0).align = :left
      row(0).columns(2..5).align = :right
    end
  end

  def footer(pdf)
    pdf.move_down 20
    pdf.text "Thank you for banking with Bhutan National Bank Ltd.",
             size: 9,
             align: :center
  end

  def format_currency(amount)
    ActionController::Base.helpers.number_to_currency(
      amount,
      unit: "Nu ",
      precision: 2
    )
  end

  def formatted_name_with_cid
    name = invoice.customer.name.to_s.titleize
    cid  = invoice.customer.cid.presence
    cid ? "#{name} (#{cid})" : name
  end
end
