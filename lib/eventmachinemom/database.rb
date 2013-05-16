require 'sqlite3'
require 'active_record'

# Database is not to be instantiated.
# It supports one table:
#   1. logs. Stores every message for a session in the database.

module EventMachineMOM 
  class Database
    extend BaseLogger

    def self.initialize_database
      dbconfig = YAML::load(File.open('config/database.yml'))
      ActiveRecord::Base.establish_connection(dbconfig)

      sql = 'CREATE TABLE IF NOT EXISTS sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name STRING,
      text STRING);'

      st = ActiveRecord::Base.connection.raw_connection.prepare(sql)
      st.execute
    end

    initialize_database

  end
end
