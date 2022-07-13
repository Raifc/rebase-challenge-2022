# frozen_string_literal: true

require 'csv'
require 'sinatra'
require 'rack/handler/puma'
require_relative './config/my_database_connector'

get '/tests' do
    db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'development'))
    tests_data = db.select_all(table_name: 'tests')

    final_data = tests_data.to_a.map do |row|
      row.delete('id')

      row
    end

    final_data.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
