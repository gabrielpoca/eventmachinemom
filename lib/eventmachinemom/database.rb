
require 'sqlite3'
# Database is not to be instantiated.
# It supports one table:
#   1. logs. Stores every message for a session in the database.

module EventMachineMOM 
  class Database
    extend BaseLogger

    class << self
      attr_accessor :db
    end

    def self.initialize_database
      @db = SQLite3::Database.new 'development.db'
      @db.execute 'CREATE TABLE IF NOT EXISTS logs (
      id integer,
      name string,
      text text
    );'
    end

    initialize_database

    def self.find name
      @db.execute "SELECT text FROM logs 
      WHERE name = #{name} ORDER BY id"
    end

  end
end
