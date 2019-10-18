require 'rbsql/version'
require 'rbsql/debug'

require 'pg_query'

module Rbsql
  def self.database(name)
    Database.new(name)
  end

  class Database
    attr_reader :name, :tables

    def initialize(name)
      @name = name
      @tables = {}
    end

    def execute(query)
      pg_query = PgQuery.parse(query)
      first_statement = pg_query.tree.first.dig('RawStmt', 'stmt')

      case first_statement.keys.first      
      when 'CreateStmt'
        statement = first_statement['CreateStmt']
        table = statement.dig('relation', 'RangeVar', 'relname')
        @tables[table] = []
      when 'InsertStmt'
        statement = first_statement['InsertStmt']
        table = statement.dig('relation', 'RangeVar', 'relname')

        puts 'getting values'

        columns = statement['cols'].map { |c| c.dig('ResTarget', 'name') }
        values = statement
          .dig('selectStmt', 'SelectStmt', 'valuesLists')[0]
          .map { |l| l.dig('A_Const', 'val', 'Integer', 'ival') }

        @tables[table] << columns.zip(values).to_h

      when 'SelectStmt'
        statement = first_statement['SelectStmt']
        from = statement['fromClause'][0].dig('RangeVar', 'relname')

        @tables[from]
      end
    end
  end
end
