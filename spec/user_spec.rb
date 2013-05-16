require 'spec_helper'

module EventMachineMOM
  describe User do

    it 'stores instance variables' do
      (1..4).each {|n| User.create("Something #{n}") }
      User.all.size.should eql 4
    end

  end
end
