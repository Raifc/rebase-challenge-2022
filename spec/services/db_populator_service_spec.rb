require_relative '../.././services/db_service'

describe DbPopulatorService do

  before :each do
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))
    @db.drop_table_if_exists(table_name: 'tests')
    DbService.reset('test_file.csv')
  end
  
  it 'should successfully populate with given csv file' do
    expected_data = {"id"=>"11", "cpf"=>"048.973.170-88", "nome_paciente"=>"Nome Completo Teste", "email_paciente"=>"gerald.crona@ebert-quigley.com", "data_nascimento_paciente"=>"2001-03-11", "endereco_rua_paciente"=>"165 Rua Rafaela", "cidade_paciente"=>"Ituverava", "estado_patiente"=>"Alagoas", "crm_medico"=>"B000BJ20J4", "crm_medico_estado"=>"PI", "nome_medico"=>"Maria Luiza Pires", "email_medico"=>"denna@wisozk.biz", "token_resultado_exame"=>"IQCZ17", "data_exame"=>"2021-08-05", "tipo_exame"=>"ácido úrico", "limites_tipo_exame"=>"15-61", "resultado_tipo_exame"=>"2"}

    @db.reset_table(table_name: 'tests')
    DbPopulatorService.populate_from_file('./fixtures/test_file.csv', db: @db, file_type: 'csv', drop_table: true, table_name: 'tests')
    tests_data = @db.select_all(table_name: 'tests').to_a

    expect(tests_data.last).to eq(expected_data)
  end

  it 'should not drop the table and populate with given csv file' do
    expected_data = {"id"=>"22", "cpf"=>"048.973.170-88", "nome_paciente"=>"Nome Completo Teste", "email_paciente"=>"gerald.crona@ebert-quigley.com", "data_nascimento_paciente"=>"2001-03-11", "endereco_rua_paciente"=>"165 Rua Rafaela", "cidade_paciente"=>"Ituverava", "estado_patiente"=>"Alagoas", "crm_medico"=>"B000BJ20J4", "crm_medico_estado"=>"PI", "nome_medico"=>"Maria Luiza Pires", "email_medico"=>"denna@wisozk.biz", "token_resultado_exame"=>"IQCZ17", "data_exame"=>"2021-08-05", "tipo_exame"=>"ácido úrico", "limites_tipo_exame"=>"15-61", "resultado_tipo_exame"=>"2"}

    @db.reset_table(table_name: 'tests')
    DbPopulatorService.populate_from_file('./fixtures/test_file.csv', db: @db, file_type: 'csv', drop_table: true, table_name: 'tests')
    DbPopulatorService.populate_from_file('./fixtures/test_file.csv', db: @db, file_type: 'csv', drop_table: false, table_name: 'tests')
    tests_data = @db.select_all(table_name: 'tests').to_a

    expect(tests_data.last).to eq(expected_data)
  end


  it 'should fail with a file type different from csv' do
    @db.reset_table(table_name: 'tests')
    result = DbPopulatorService.populate_from_file('./fixtures/test_file.csv', db: @db, file_type: 'json', drop_table: true, table_name: 'tests')

    expect(result).to eq false
  end

end
