require 'yaml'
require 'pg'

# Database Connector
class MyDatabaseConnector
  def initialize(database:)
    db_config = YAML.load_file('config/database.yml')[ENV.fetch('RACK_ENV')]

    @user = db_config['username']
    @password = db_config['password']
    @port = db_config['port']
    @host = db_config['host']
    @database = "rebase_challenge_#{database}"
    @connection = nil
    connect
  end

  def run_query(query:)
    return false if @connection.nil?

    @connection.exec(query)
  end

  def create_table(table_name:, fields:)
    return false if @connection.nil?

    fields_as_string = fields.join(',')

    query = "CREATE TABLE #{table_name} (#{fields_as_string})"

    run_query(query: query)
  end

  def insert_row_data(table_name:, columns:, row_data:)
    return false if @connection.nil?

    columns_data = columns.join(',')
    row_data = row_data.map { |column| "$$#{column}$$" }
    data = row_data.join(',')

    query = "INSERT INTO #{table_name} (#{columns_data}) VALUES (#{data})"

    run_query(query: query)
  end

  def drop_table_if_exists(table_name:)
    return false if @connection.nil?

    run_query(query: "DROP TABLE IF EXISTS #{table_name}")
  end

  def select_all(table_name:)
    return false if @connection.nil?

    run_query(query: "SELECT * FROM #{table_name}")
  end

  def reset_table(table_name:)
    return false if @connection.nil?

    run_query(query: "TRUNCATE ONLY #{table_name} RESTART IDENTITY;")
  end

  private

  def connect
    @connection = PG.connect(user: @user, password: @password, port: @port, host: @host)
  end
end
