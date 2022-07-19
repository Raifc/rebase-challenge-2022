# frozen_string_literal: true

require 'csv'
require 'sinatra'
require 'rack/handler/puma'
require_relative './config/my_database_connector'
require_relative './workers/import_worker'

# Server Application
class Application < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 3000
  set :server, 'puma'
  set :json_encoder, :to_json

  before do
    content_type 'application/json'
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'development'))
  end

  get '/tests' do
    tests_data = @db.select_all(table_name: 'tests')

    final_data = tests_data.to_a.map do |row|
      row.delete('id')

      row
    end

    final_data.to_json
  end

  post '/import' do
    payload = JSON.parse(request.body.read)
    filename = payload.fetch('filename', false)
    table_name = payload.fetch('table_name', false)

    if filename && table_name
      target = File.join('fixtures', filename)

      ImportJob.perform_async(target, true, table_name)
      { message: 'Import has been finished' }.to_json
    else
      [500, { message: 'filename or table_name are missing' }.to_json]
    end

  rescue StandardError => e
    puts e
    [500, { message: 'Something went wrong' }.to_json]
  end
end

# Rack::Handler::Puma.run(
#   Sinatra::Application,
#   Port: 3000,
#   Host: '0.0.0.0'
# )
