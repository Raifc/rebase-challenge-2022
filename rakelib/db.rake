# frozen_string_literal: true

require_relative '../config/my_database_connector'
require_relative '../services/db_service'

namespace :db do
  desc 'Reset the DB (Drop + Create + Populate)'
  task :reset do
    puts '=== Resetting the DB ==='
    DbService.reset('data.csv')
    puts '=== Done ==='
  end

  desc 'Create Databases for the environments'
  task :create do
    puts '=== Creating Databases ==='
    DbService.create_databases
    puts '=== Done ==='
  end
end
