describe 'Server endpoints', type: :request do
  before do
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
    DbService.reset('test_file.csv')
  end

  context "Successfull request" do
    it 'should successfully complete the request' do
      expect_any_instance_of(MyDatabaseConnector).to receive(:reset_table).exactly(1)

      delete '/clean_test_table'

      expect(last_response.status).to eq 200
    end
  end

  context "Failed request" do
    it 'should return 500 if the request can not be processed properly' do
      allow(STDOUT).to receive(:puts)
      allow_any_instance_of(MyDatabaseConnector).to receive(:reset_table).and_raise(StandardError)
      expected_response = { "message": "Something went wrong" }

      delete '/clean_test_table'

      expect(last_response.status).to eq 500
      expect(last_response.body).to include(expected_response.to_json)
    end
  end
end
