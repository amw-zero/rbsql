require 'json'

module Rbsql
  def self.pretty_print(pg_query)
    puts JSON.pretty_generate pg_query.tree.first['RawStmt']['stmt']
  end
end