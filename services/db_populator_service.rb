# frozen_string_literal: true

require 'i18n'
require 'csv'
I18n.config.available_locales = :en

# DB Populator Service
module DbPopulatorService
  TYPE_MAP = {
    'String' => 'VARCHAR(255)',
    'Integer' => 'VARCHAR(255)'
  }.freeze

  def self.parse_columns_type(csv_data)
    row = csv_data.first(2).last

    db_columns_with_data_type = ['id serial PRIMARY KEY']
    db_columns = []

    row.each_pair do |key, value|
      normalized_key = I18n.transliterate(key).strip.tr('/', ' ').tr(' ', '_')
      key_type = value.class.to_s
      column_type = TYPE_MAP.fetch(key_type, 'VARCHAR(255)')

      db_columns_with_data_type << "#{normalized_key} #{column_type}"
      db_columns << normalized_key
    end

    [db_columns_with_data_type, db_columns]
  end

  def self.populate_from_file(file_path, db:, file_type: 'csv', drop_table: false, table_name: 'tests')
    return false unless file_type == 'csv'

    csv_data = CSV.table(file_path, col_sep: ';', header_converters: nil, headers: true)

    columns_with_data_type, columns_names = parse_columns_type(csv_data)

    if drop_table
      db.drop_table_if_exists(table_name: table_name)
      db.create_table(table_name: table_name, fields: columns_with_data_type)
    end

    csv_to_iterate = csv_data.drop(1)

    csv_to_iterate.each do |record|
      db.insert_row_data(table_name: table_name, columns: columns_names, row_data: record.fields)
    end

    true
  end
end
