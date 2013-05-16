require 'spec_helper'

module EventMachineMOM
  describe Channel do

    it 'stores a user' do
      c = Channel.create "dummy channel"
      u = User.new "Something"
      c.add_user u
      c.contains?(u).should be_true
    end

    it 'creates a new channel by name when one doesnt exist' do
      Channel.find_or_create("demo").class.should_not be_nil
    end

    it 'doesnt create a channel when there is one' do
      channel = Channel.create "dummy"
      Channel.find_or_create("dummy").should eql channel
    end

    it 'stores the logs on push' do
      
    end

  end
end
