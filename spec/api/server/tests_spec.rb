# frozen_string_literal: true

require 'rspec'
require_relative '../../spec_helper'

describe 'Server endpoints', type: :request do
  context "Tests Data" do
    before do
      @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV'))
      @db.reset_table(table_name: 'tests')
      column_info = %w[cpf nome_paciente email_paciente data_nascimento_paciente endereco_rua_paciente cidade_paciente estado_patiente crm_medico crm_medico_estado nome_medico email_medico token_resultado_exame data_exame tipo_exame limites_tipo_exame resultado_tipo_exame].freeze
      test_1 = ["048.973.170-88", "Emilly Batista Neto", "gerald.crona@ebert-quigley.com", "2001-03-11", "165 Rua Rafaela", "Ituverava", "Alagoas", "B000BJ20J4", "PI", "Maria Luiza Pires", "denna@wisozk.biz", "IQCZ17", "2021-08-05", "leucócitos", "9-61", "89"].freeze
      test_2 = ["071.488.453-78", "Antônio Rebouças", "adalberto_grady@feil.org", "1999-04-11", "25228 Travessa Ladislau", "Tefé", "Sergipe", "B0002W2RBG", "SP", "Dra. Isabelly Rêgo", "diann_klein@schinner.org", "AIWH8Y", "2021-06-29", "ácido úrico", "15-61", "43"].freeze

      @db.insert_row_data(table_name: 'tests', columns: column_info, row_data: test_1)
      @db.insert_row_data(table_name: 'tests', columns: column_info, row_data: test_2)
    end

    describe 'GET /tests' do
      it 'should successfully complete the request' do
        headers = { 'CONTENT_TYPE' => 'application/json' }

        expected_headers = { "Content-Length" => "1039",
                             "X-Content-Type-Options" => "nosniff",
                             'Content-Type' => 'application/json' }
        expected_response = [{"cpf":"048.973.170-88","nome_paciente":"Emilly Batista Neto","email_paciente":"gerald.crona@ebert-quigley.com","data_nascimento_paciente":"2001-03-11","endereco_rua_paciente":"165 Rua Rafaela","cidade_paciente":"Ituverava","estado_patiente":"Alagoas","crm_medico":"B000BJ20J4","crm_medico_estado":"PI","nome_medico":"Maria Luiza Pires","email_medico":"denna@wisozk.biz","token_resultado_exame":"IQCZ17","data_exame":"2021-08-05","tipo_exame":"leucócitos","limites_tipo_exame":"9-61","resultado_tipo_exame":"89"},{"cpf":"071.488.453-78","nome_paciente":"Antônio Rebouças","email_paciente":"adalberto_grady@feil.org","data_nascimento_paciente":"1999-04-11","endereco_rua_paciente":"25228 Travessa Ladislau","cidade_paciente":"Tefé","estado_patiente":"Sergipe","crm_medico":"B0002W2RBG","crm_medico_estado":"SP","nome_medico":"Dra. Isabelly Rêgo","email_medico":"diann_klein@schinner.org","token_resultado_exame":"AIWH8Y","data_exame":"2021-06-29","tipo_exame":"ácido úrico","limites_tipo_exame":"15-61","resultado_tipo_exame":"43"}]
        get('/tests', nil, headers)

        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_response.to_json)
        expect(last_response.headers).to eq(expected_headers)
      end
    end
  end
end
