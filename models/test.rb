# frozen_string_literal: true

# Model test for building response
class Test
  def initialize(db:)
    @db = db
    @table_name = 'tests'
  end

  def build_final_data(token)
    patient_final_data = patient_and_test_data(token).to_a
    tests_data = tests_data(token).to_a
    doctor_data = doctor_data(token).to_a

    return [] if patient_final_data.empty? || tests_data.empty? || doctor_data.empty?

    result = patient_final_data.first
    result = result.merge('Médico' => doctor_data.first)
    result.merge('Exames' => tests_data)
  end

  def tests_data(token)
    query = "SELECT tipo_exame, limites_tipo_exame, resultado_tipo_exame from #{@table_name} WHERE token_resultado_exame = '#{token}'"

    @db.run_query(query: query)
  end

  def doctor_data(token)
    query = "SELECT nome_medico, crm_medico, crm_medico_estado FROM #{@table_name} WHERE token_resultado_exame = '#{token}'"

    @db.run_query(query: query)
  end

  def patient_and_test_data(token)
    query = "SELECT token_resultado_exame, data_exame, cpf, nome_paciente, email_paciente, data_nascimento_paciente
FROM #{@table_name} WHERE token_resultado_exame = '#{token}'"

    @db.run_query(query: query)
  end
end
