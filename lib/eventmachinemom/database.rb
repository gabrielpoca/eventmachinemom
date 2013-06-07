require 'pg'
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
      text TEXT);

      CREATE TABLE IF NOT EXISTS servers (
      id SERIAL PRIMARY KEY,
      host VARCHAR,
      active BOOLEAN);'

      ActiveRecord::Base.connection.execute(sql)

      begin 
      sequence_sql = 'CREATE SEQUENCE user_id START 1;'
      ActiveRecord::Base.connection.execute(sequence_sql);
      rescue Exception => e
        puts e.message
      end
    end

    def self.get_next_user_id
        ActiveRecord::Base.connection.execute("SELECT nextval('user_id');").first['nextval'].to_i
    end

    initialize_database

  end
end
