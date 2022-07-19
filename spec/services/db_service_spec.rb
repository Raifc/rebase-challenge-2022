# frozen_string_literal: true

require 'rspec'
require_relative '.././spec_helper'
require_relative '../.././services/db_service'

describe DbService do
  it 'should reset the db with given csv file' do
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
    @db.reset_table(table_name: 'tests')
    expected_first_result = {"id"=>"1", "cpf"=>"048.973.170-88", "nome_paciente"=>"Nome Completo Teste", "email_paciente"=>"gerald.crona@ebert-quigley.com", "data_nascimento_paciente"=>"2001-03-11", "endereco_paciente"=>"165 Rua Rafaela", "cidade_paciente"=>"Ituverava", "estado_patiente"=>"Alagoas", "crm_medico"=>"B000BJ20J4", "crm_medico_estado"=>"PI", "nome_medico"=>"Maria Luiza Pires", "email_medico"=>"denna@wisozk.biz", "token_resultado_exame"=>"IQCZ17", "data_exame"=>"2021-08-05", "tipo_exame"=>"plaquetas", "limites_tipo_exame"=>"11-93", "resultado_tipo_exame"=>"97"}
    expected_last_result = {"id"=>"11", "cpf"=>"048.973.170-88", "nome_paciente"=>"Nome Completo Teste", "email_paciente"=>"gerald.crona@ebert-quigley.com", "data_nascimento_paciente"=>"2001-03-11", "endereco_paciente"=>"165 Rua Rafaela", "cidade_paciente"=>"Ituverava", "estado_patiente"=>"Alagoas", "crm_medico"=>"B000BJ20J4", "crm_medico_estado"=>"PI", "nome_medico"=>"Maria Luiza Pires", "email_medico"=>"denna@wisozk.biz", "token_resultado_exame"=>"IQCZ17", "data_exame"=>"2021-08-05", "tipo_exame"=>"ácido úrico", "limites_tipo_exame"=>"15-61", "resultado_tipo_exame"=>"2"}

    DbService.reset('test_file.csv')
    result = @db.select_all(table_name: 'tests').to_a

    expect(result.first).to eq(expected_first_result)
    expect(result.last).to eq(expected_last_result)
  end

  it 'should not reset the db with wrong ENV' do
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
    @db.reset_table(table_name: 'tests')
    expect(DbService).to receive(:puts).exactly(1)
    expect(ENV).to receive(:fetch).with('RACK_ENV').and_return(nil)

    DbService.reset('test_file.csv')
  end
end
