# frozen_string_literal: true

require_relative '../config/my_database_connector'
require 'csv'

ALLOWED_ENVS = %w[test development production].freeze
COLUMNS_WITH_DATA_TYPE = ['id serial PRIMARY KEY', 'cpf VARCHAR(255)', 'nome_paciente VARCHAR(255)',
                          'email_paciente VARCHAR(255)', 'data_nascimento_paciente DATE',
                          'endereco_paciente VARCHAR(255)', 'cidade_paciente VARCHAR(255)',
                          'estado_patiente VARCHAR(255)', 'crm_medico VARCHAR(255)', 'crm_medico_estado VARCHAR(255)',
                          'nome_medico VARCHAR(255)', 'email_medico VARCHAR(255)', 'token_resultado_exame VARCHAR(255)',
                          'data_exame DATE', 'tipo_exame VARCHAR(255)', 'limites_tipo_exame VARCHAR(255)',
                          'resultado_tipo_exame VARCHAR(255)'].freeze

COLUMNS_NAMES = %w[cpf nome_paciente email_paciente data_nascimento_paciente endereco_paciente cidade_paciente
                   estado_patiente crm_medico crm_medico_estado nome_medico email_medico token_resultado_exame data_exame tipo_exame
                   limites_tipo_exame resultado_tipo_exame].freeze

namespace :db do
  desc 'Reset the DB (Drop + Create + Populate)'
  task :reset do
    ENV['RACK_ENV'] ||= 'development'
    env = ENV.fetch('RACK_ENV')
    table_name = 'tests'

    csv_data_only = CSV.read('fixtures/data.csv', col_sep: ';', header_converters: nil, headers: true).drop(1)

    puts '=== Resetting the DB ==='

    if ALLOWED_ENVS.include?(env)
      db = MyDatabaseConnector.new(database: env)
      db.drop_table_if_exists(table_name: table_name)
      db.create_table(table_name: table_name, fields: COLUMNS_WITH_DATA_TYPE)

      csv_data_only.each do |record|
        db.insert_row_data(table_name: table_name, columns: COLUMNS_NAMES, row_data: record.fields)
      end

    else
      puts 'Check your environment settings'
    end
    puts '=== All Done ==='
  end
end
