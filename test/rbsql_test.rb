require "test_helper"

class RbsqlTest < Minitest::Test
  def test_selecting_from_table
    db = Rbsql.database('test_db')
    db.execute('CREATE TABLE test_table (value integer)')
    db.execute('INSERT INTO test_table (value) VALUES(5)')

    result = db.execute('SELECT * FROM test_table')

    assert_equal [{ 'value' => 5 }], result
  end

  def test_where_equals
    db = Rbsql.database('test_db')
    db.execute('CREATE TABLE test_table (value integer)')
    db.execute('INSERT INTO test_table (value) VALUES(5)')
    db.execute('INSERT INTO test_table (value) VALUES(6)')

    result = db.execute('SELECT * FROM test_table WHERE value = 6')

    assert_equal [{ 'value' => 6 }], result
  end
end
