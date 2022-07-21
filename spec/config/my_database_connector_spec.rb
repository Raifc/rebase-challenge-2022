require 'pg'

describe MyDatabaseConnector do
  subject { MyDatabaseConnector.new }

  context '#new' do
    it 'should call the connect method' do
      expect_any_instance_of(MyDatabaseConnector).to receive(:connect).once

      MyDatabaseConnector.new
    end

    it 'should not call the connect method with auto-connect false' do
      expect_any_instance_of(MyDatabaseConnector).not_to receive(:connect)

      MyDatabaseConnector.new(false)
    end
  end

  context '#run_query' do
    it 'should be false as connection fails' do
      allow(PG).to receive(:connect).and_return(nil)
      query = 'EXPECTED QUERY'

      result = subject.run_query(query: query)

      expect(result).to eq(false)
    end

    it 'should be false for select_all as connection fails' do
      allow(PG).to receive(:connect).and_return(nil)

      result = subject.select_all(table_name: nil)

      expect(result).to eq(false)
    end

    it 'should be false for reset_table as connection fails' do
      allow(PG).to receive(:connect).and_return(nil)

      result = subject.reset_table(table_name: nil)

      expect(result).to eq(false)
    end

    it 'should call the expected methods only once' do
      query = 'EXPECTED QUERY'

      expect_any_instance_of(PG::Connection).to receive(:exec).with(query).once

      subject.run_query(query: query)
    end
  end

  context '#create_table' do
    it 'should be false as connection fails' do
      allow(PG).to receive(:connect).and_return(nil)

      result = subject.create_table(table_name: nil, fields: nil)

      expect(result).to eq(false)
    end

    it 'should call #run_query from #create_table' do
      table_name = 'SAMPLE_TABLE'
      column_fields = ['id PRIMARY KEY', 'name TEXT', 'age INTEGER']
      expected_fields = 'id PRIMARY KEY,name TEXT,age INTEGER'
      query = "CREATE TABLE #{table_name} (#{expected_fields})"

      expect(subject).to receive(:run_query).with(query: query).once

      subject.create_table(table_name: table_name, fields: column_fields)
    end
  end

  context '#insert_row_data' do
    it 'should be false as connection fails' do
      allow(PG).to receive(:connect).and_return(nil)

      result = subject.insert_row_data(table_name: nil, columns: nil, row_data: nil)

      expect(result).to eq(false)
    end

    it 'should call #run_query from #insert_row_data' do
      table_name = 'SAMPLE_TABLE_2'
      column_fields = %w[C1 C2 C3]
      values = %w[A 9 C]
      query = "INSERT INTO SAMPLE_TABLE_2 (C1,C2,C3) VALUES ($$A$$,$$9$$,$$C$$)"

      expect(subject).to receive(:run_query).with(query: query).once

      subject.insert_row_data(table_name: table_name, columns: column_fields, row_data: values)
    end
  end

  context '#drop_table_if_exists' do
    it 'should be false as connection fails' do
      table_name = 'SAMPLE_TABLE_3'
      allow(PG).to receive(:connect).and_return(nil)

      result = subject.drop_table_if_exists(table_name: table_name)

      expect(result).to eq(false)
    end

    it 'should call #run_query from #drop_table_if_exists' do
      table_name = 'SAMPLE_TABLE_3'
      query = "DROP TABLE IF EXISTS SAMPLE_TABLE_3"

      expect(subject).to receive(:run_query).with(query: query).once

      subject.drop_table_if_exists(table_name: table_name)
    end
  end

  context '#connect' do
    it 'should set the connection attribute with a PG::Connection' do
      result = subject.send(:connect)

      expect(result).not_to be_nil
      expect(result.class.to_s).to eq('PG::Connection')
    end

    it 'should create a new database and connect when there are no databases yet' do
      db = MyDatabaseConnector.new
      allow(PG).to receive(:connect).and_raise(PG::ConnectionBad, 'database does not exist')
      allow(db).to receive(:create_missing_database).and_return(true)

      result = db.send(:connect)

      expect(result).to eq(true)
    end

    it 'should create a new database when connection fails' do
      allow(PG).to receive(:connect).and_raise(PG::ConnectionBad, 'something went')
      allow(subject).to receive(:create_missing_database).and_return(true)

      subject.send(:connect)
    end
  end

  context '#create_missing_database' do
    it 'should create a new database when the method is crete_missing_database executed' do
      expect(subject).to receive(:puts).exactly(1)
      expect(subject).to receive(:create_database).and_return(true)
      expect(PG).to receive(:connect).and_return(true)

      result = subject.send(:create_missing_database)

      expect(result).to eq(true)
    end
  end

  context '#create_database' do
    it 'raise' do
      db = MyDatabaseConnector.new
      expect(db).to receive(:puts).once
      expect(PG).to receive(:connect).and_raise(PG::DuplicateDatabase)
      db.create_database
    end

    it 'should set the connection attribute with a PG::Connection' do
      conn_stub = double('PG::Connection')
      db = MyDatabaseConnector.new

      expect(PG).to receive(:connect).and_return(conn_stub).once
      expect(conn_stub).to receive(:exec).once

      db.create_database
    end
  end
end