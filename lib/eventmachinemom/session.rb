module EventMachineMOM 
  class Session < ActiveRecord::Base
    set_table_name "sessions"
    attr_accessible :id, :name, :text
  end
end
