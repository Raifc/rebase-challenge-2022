describe Test do

  before(:each) do
    @db = MyDatabaseConnector.new
    DbService.reset('test_file.csv')
  end

  it 'should sucessfully build the result with given token' do
    test = Test.new(db: @db)
    result = test.build_final_data('IQCZ17').to_json

    values = %w[token_resultado_exame IQCZ17 data_exame 2021-08-05 cpf 048.973.170-88 nome_paciente Nome Completo Teste email_paciente gerald.crona@ebert-quigley.com data_nascimento_paciente 2001-03-11 Médico nome_medico Maria Luiza Pires tipo_exame plaquetas limites_tipo_exame 11-93 vldl 87]

    values.each do |current_value|
      expect(result).to include(current_value)
    end
  end

  it 'should return an empty array if the token does not exist' do
    tests = Test.new(db: @db)
    token = 'TOKEN'
    expected_result = []

    result = tests.build_final_data(token)

    expect(result).to eq(expected_result)
  end

end
