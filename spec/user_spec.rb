require 'spec_helper'

describe EventMachineMOM::User do

  it 'stores instance variables' do
    (1..4).each {|n| EventMachineMOM::User.create("Something #{n}") }
    EventMachineMOM::User.all.size.should eql 4
  end

  it 'saves the right object' do
    u = EventMachineMOM::User.new "Something"
    EventMachineMOM::User.create "Something"
    EventMachineMOM::User.all.last.should == u
  end

end
