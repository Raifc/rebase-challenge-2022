# frozen_string_literal: true

require 'rspec'
require_relative '../../spec_helper'
require_relative '../../../services/db_service'

describe 'POST /import' do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  context "Imports Data" do
    before :each do
      @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
      @db.drop_table_if_exists(table_name: 'tests')
      DbService.reset('test_file.csv')
    end

    it 'should successfully complete the request' do
      body = JSON.generate("filename" => "test_file.csv", "table_name" => "tests")
      expect(ImportJob).to receive(:perform_async).and_return(true)

      post('/import', body, headers)

      expect(last_response.status).to eq 201
      expect(last_response.body).to include('File successfully scheduled to be imported')
    end

    it 'response status should be 500 with wrong request body' do
      body = JSON.generate("wrong" => "file.csv")

      post('/import', body, headers)

      expect(last_response.status).to eq 500
      expect(last_response.body).to include('Filename or table_name are missing')
    end
  end

  context 'Failed request' do
    describe "GET /tests" do
      it 'should return 500 if the request can not be processed properly' do
        allow(STDOUT).to receive(:puts)
        body = JSON.generate("filename" => "test_file.csv", "table_name" => "tests")
        allow(ImportJob).to receive(:perform_async).and_raise(StandardError)

        post('/import', body, headers)

        expect(last_response.status).to eq 500
        expect(last_response.body).to include('Something went wrong')
      end
    end
  end

end
