# frozen_string_literal: true

require 'rspec'
require_relative '../../spec_helper'
require_relative '../../../services/db_service'

describe 'Server endpoints', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  context "Sending valid token" do
    before(:each) do
      @db = MyDatabaseConnector.new
      DbService.reset('test_file.csv')
    end

    it 'should successfully complete the request' do
      expected_headers = { "Content-Length" => "1209",
                           "X-Content-Type-Options" => "nosniff",
                           'Content-Type' => 'application/json' }
      expected_response = { "token_resultado_exame": "IQCZ17", "data_exame": "2021-08-05", "cpf": "048.973.170-88", "nome_paciente": "Nome Completo Teste", "email_paciente": "gerald.crona@ebert-quigley.com", "data_nascimento_paciente": "2001-03-11", "Médico": { "nome_medico": "Maria Luiza Pires", "crm_medico": "B000BJ20J4", "crm_medico_estado": "PI" }, "Exames": [{ "tipo_exame": "plaquetas", "limites_tipo_exame": "11-93", "resultado_tipo_exame": "97" }, { "tipo_exame": "hdl", "limites_tipo_exame": "19-75", "resultado_tipo_exame": "0" }, { "tipo_exame": "ldl", "limites_tipo_exame": "45-54", "resultado_tipo_exame": "80" }, { "tipo_exame": "vldl", "limites_tipo_exame": "48-72", "resultado_tipo_exame": "82" }, { "tipo_exame": "glicemia", "limites_tipo_exame": "25-83", "resultado_tipo_exame": "98" }, { "tipo_exame": "tgo", "limites_tipo_exame": "50-84", "resultado_tipo_exame": "87" }, { "tipo_exame": "tgp", "limites_tipo_exame": "38-63", "resultado_tipo_exame": "9" }, { "tipo_exame": "eletrólitos", "limites_tipo_exame": "2-68", "resultado_tipo_exame": "85" }, { "tipo_exame": "tsh", "limites_tipo_exame": "25-80", "resultado_tipo_exame": "65" }, { "tipo_exame": "t4-livre", "limites_tipo_exame": "34-60", "resultado_tipo_exame": "94" }, { "tipo_exame": "ácido úrico", "limites_tipo_exame": "15-61", "resultado_tipo_exame": "2" }] }

      get('/tests/IQCZ17', nil, headers)

      expect(last_response.status).to eq 201
      expect(last_response.body).to eq(expected_response.to_json)
      expect(last_response.headers).to eq(expected_headers)
    end
  end

  context "Sending invalid token" do
    it 'should be 500 when token does not exist' do
      token = 'TOKEN'
      expected_response = { "message": "We could not find any data with token: #{token}" }

      get('/tests/TOKEN', nil, headers)

      expect(last_response.status).to eq 500
      expect(last_response.body).to eq(expected_response.to_json)
    end
  end

  context "Failed request" do
    it 'should return 500 if the request can not be processed properly' do
      allow(STDOUT).to receive(:puts)
      allow_any_instance_of(MyDatabaseConnector).to receive(:run_query).and_raise(StandardError)
      expected_response = { "message": "Something went wrong" }

      get('/tests/IQCZ17', nil, headers)

      expect(last_response.status).to eq 500
      expect(last_response.body).to include(expected_response.to_json)
    end

  end
end
