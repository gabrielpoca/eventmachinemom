require 'spec_helper'

module EventMachineMOM
  describe User do

    it 'stores instance variables' do
      (1..4).each {|n| User.create("Something #{n}") }
      User.all.size.should eql 4
    end

    it 'saves the right object' do
      u = User.new "Something"
      User.create "Something"
      User.all.last.should == u
    end

  end
end
