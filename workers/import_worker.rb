# frozen_string_literal: true

require 'sidekiq'
require './services/db_populator_service'
require_relative '../config/my_database_connector'

# Sidekiq worker
class ImportJob
  include Sidekiq::Job

  def perform(file_path, table_name)
    @db = MyDatabaseConnector.new

    DbPopulatorService.populate_from_file(file_path, db: @db, file_type: 'csv',
                                                     table_name: table_name)
  end
end
