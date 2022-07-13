describe MyDatabaseConnector do
  subject { MyDatabaseConnector.new(database: 'test') }

  #TODO checar o motivo de o banco de dados estar se sobrescrevendo em ambientes diferentes
  context '#new' do
    it 'should call the connect method' do
      expect_any_instance_of(MyDatabaseConnector).to receive(:connect).once
      MyDatabaseConnector.new(database: 'test')
    end
  end

  context '#run_query' do
    # TODO fazer o false
    it 'should call the expected methods only once' do
      query = 'EXPECTED QUERY'

      expect_any_instance_of(PG::Connection).to receive(:exec).with(query).once

      subject.run_query(query: query)
    end
  end

  context '#create_table' do
    # TODO fazer o false
    it 'should call #run_query from #create_table' do
      table_name = 'SAMPLE_TABLE'
      column_fields = ['id PRIMARY KEY', 'name TEXT', 'age INTEGER']
      expected_fields = 'id PRIMARY KEY,name TEXT,age INTEGER'
      query = "CREATE TABLE #{table_name} (#{expected_fields});"

      expect(subject).to receive(:run_query).with(query: query).once

      subject.create_table(table_name: table_name, fields: column_fields)
    end
  end

  context '#insert_row_data' do
    # TODO fazer o false
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
    # TODO fazer o false
    it 'should call #run_query from #drop_table_if_exists' do
      table_name = 'SAMPLE_TABLE_3'
      column_fields = %w[C1 C2 C3]
      values = %w[A 9 C]
      query = "INSERT INTO SAMPLE_TABLE_3 (C1,C2,C3) VALUES ($$A$$,$$9$$,$$C$$)"

      expect(subject).to receive(:run_query).with(query: query).once

      subject.insert_row_data(table_name: table_name, columns: column_fields, row_data: values)
    end
  end

  context '#connect' do
    it 'should set the connection attribute with a PG::Connection' do
      db = MyDatabaseConnector.new(database: 'test')

      result = db.send(:connect)

      expect(result).not_to be_nil
      expect(result.class.to_s).to eq('PG::Connection')
    end
  end
end