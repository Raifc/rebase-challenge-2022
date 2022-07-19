# frozen_string_literal: true

require 'sidekiq'
require './services/db_populator_service'
require_relative '../config/my_database_connector'

# Sidekiq worker
class ImportJob
  include Sidekiq::Job

  def perform(file_path, drop_table, table_name)
    @db = MyDatabaseConnector.new(database: ENV.fetch('RACK_ENV', 'test'))

    DbPopulatorService.populate_from_file(file_path, db: @db, file_type: 'csv', drop_table: drop_table,
                                                     table_name: table_name)
  end
end
