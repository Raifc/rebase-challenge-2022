# frozen_string_literal: true

require_relative '../config/my_database_connector'
require 'csv'

# Module for db utils
module DbService
  @allowed_envs = %w[test development production].freeze
  @columns_with_data_type = ['id serial PRIMARY KEY', 'cpf VARCHAR(255)', 'nome_paciente VARCHAR(255)',
                             'email_paciente VARCHAR(255)', 'data_nascimento_paciente DATE',
                             'endereco_paciente VARCHAR(255)', 'cidade_paciente VARCHAR(255)',
                             'estado_patiente VARCHAR(255)', 'crm_medico VARCHAR(255)', 'crm_medico_estado VARCHAR(255)',
                             'nome_medico VARCHAR(255)', 'email_medico VARCHAR(255)', 'token_resultado_exame VARCHAR(255)',
                             'data_exame DATE', 'tipo_exame VARCHAR(255)', 'limites_tipo_exame VARCHAR(255)',
                             'resultado_tipo_exame VARCHAR(255)'].freeze

  @columns_names = %w[cpf nome_paciente email_paciente data_nascimento_paciente endereco_paciente cidade_paciente
                      estado_patiente crm_medico crm_medico_estado nome_medico email_medico token_resultado_exame data_exame tipo_exame
                      limites_tipo_exame resultado_tipo_exame].freeze

  def self.reset(filename = 'data.csv')
    env = ENV.fetch('RACK_ENV')
    table_name = 'tests'

    target = File.join('fixtures', filename)

    csv_data_only = CSV.read(target, col_sep: ';', header_converters: nil, headers: true).drop(1)

    if @allowed_envs.include?(env)
      db = MyDatabaseConnector.new
      db.drop_table_if_exists(table_name: table_name)
      db.create_table(table_name: table_name, fields: @columns_with_data_type)

      csv_data_only.each do |record|
        db.insert_row_data(table_name: table_name, columns: @columns_names, row_data: record.fields)
      end

    else
      puts 'Check your environment settings'
    end
  end

  def self.create_databases
    envs = %w[production development test]

    envs.each do |current_env|
      ENV['RACK_ENV'] = current_env

      puts "Creating #{current_env} database"
      current_db_connection = MyDatabaseConnector.new(false)
      current_db_connection.create_database
    end
  end
end
