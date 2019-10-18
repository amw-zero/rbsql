require "test_helper"

class RbsqlTest < Minitest::Test
  def test_selecting_from_table
    db = Rbsql.database('test_db')
    db.execute('CREATE TABLE test_table (value integer)')
    db.execute('INSERT INTO test_table (value) VALUES(5)')

    result = db.execute('SELECT * FROM test_table')

    assert_equal result[0], { 'value' => 5 }
  end
end
