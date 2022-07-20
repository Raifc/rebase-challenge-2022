# frozen_string_literal: true

require 'csv'
require 'sinatra'
require 'rack/handler/puma'
require_relative './config/my_database_connector'
require_relative './workers/import_worker'
require_relative './models/test'

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

    [201, final_data.to_json]

  rescue StandardError => e
    puts e
    [500, { message: 'Something went wrong' }.to_json]
  end

  post '/import' do
    payload = JSON.parse(request.body.read)
    filename = payload.fetch('filename', false)
    table_name = payload.fetch('table_name', false)

    if filename && table_name
      target = File.join('fixtures', filename)

      ImportJob.perform_async(target, true, table_name)
      [201, { message: 'File successfully scheduled to be imported' }.to_json]
    else
      [500, { message: 'Filename or table_name are missing' }.to_json]
    end

  rescue StandardError => e
    puts e
    [500, { message: 'Something went wrong' }.to_json]
  end

  get '/tests/:token' do
    token = params[:token]
    test_model = Test.new(db: @db)
    result = test_model.build_final_data(token)

    if result.empty?
      [500, { message: "We could not find any data with token: #{token}" }.to_json]
    else
      [201, result.to_json]
    end

  rescue StandardError => e
    puts e
    [500, { message: 'Something went wrong' }.to_json]
  end
end
