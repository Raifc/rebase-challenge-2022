# frozen_string_literal: true

require 'rspec'
require_relative '../../spec_helper'
require_relative '../../../services/db_service'

context "Imports Data" do
  before :each do
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
    @db.drop_table_if_exists(table_name: 'tests')
    DbService.reset('test_file.csv')
  end

  describe 'POST /import' do
    it 'should successfully complete the request' do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      body = JSON.generate("filename" => "test_file.csv", "table_name" => "tests")
      expect(ImportJob).to receive(:perform_async).and_return(true)

      post('/import', body, headers)

      expect(last_response.status).to eq 200
      expect(last_response.body).to include('Import has been finished')
    end

    it 'response status should be 500 with wrong request body' do
      headers = { 'CONTENT_TYPE' => 'application/json' }
      body = JSON.generate("wrong" => "file.csv")

      post('/import', body, headers)

      expect(last_response.status).to eq 500
      expect(last_response.body).to include('filename or table_name are missing')
    end
  end

end