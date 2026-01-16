class FetchTransactionDetailService < ApplicationService
  attr_accessor :transactions

  def run
    connection = oracle_connection
    row = fetch_row(connection)
  ensure
    @cursor&.close
    connection&.logoff
  end

  private

  attr_reader :transactions, :cursor

  def oracle_connection
    @oracle_connection ||= OracleConnectionService.new(
      db_user: ENV.fetch('DB_USER'),
      db_password: ENV.fetch('DB_PASSWORD'),
      db_host: ENV.fetch('DB_HOST'),
      db_port: ENV.fetch('DB_PORT'),
      db_service_name: ENV.fetch('DB_SERVICE_NAME')
    ).run
  end

  def fetch_row(connection)
    placeholders = transactions.map { |i| "'#{i}'" }.join(", ")

    query = <<~SQL
      SELECT *
      FROM GST_TRANSACTION_VW
      WHERE TRN_REF_NO IN (#{placeholders})
        OR EXTERNAL_REF_NO IN (#{placeholders})
    SQL

    @cursor = connection.exec(query)

    rows = []
    while (row = @cursor.fetch_hash)
      rows << row
    end

    rows
  end
end
