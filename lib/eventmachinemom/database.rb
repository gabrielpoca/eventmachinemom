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
      id SERIAL PRIMARY KEY,
      name VARCHAR,
      text TEXT);'

      st = ActiveRecord::Base.connection.execute(sql)
    end

    initialize_database

  end
end
