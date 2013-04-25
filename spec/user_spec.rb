require 'spec_helper'

describe EventMachineMOM::User do

  it 'contains instance variables' do
    EventMachineMOM::User.create "Something"
    EventMachineMOM::User.all.size.should eql 1
  end

  it 'saves the right object' do
    u = EventMachineMOM::User.new "Something"
    EventMachineMOM::User.create "Something"
    EventMachineMOM::User.all.last.should == u
  end

end

