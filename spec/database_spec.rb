require 'spec_helper'

module EventMachineMOM 
  describe Database do

    it 'should initialize the database connection' do
      Database.db.class.should eql SQLite3::Database 
    end

    it 'finds sessions by name' do
      
    end

  end
end
