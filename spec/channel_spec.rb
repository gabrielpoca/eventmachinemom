require 'spec_helper'

module EventMachineMOM
  describe Channel do

    it 'stores a user' do
      c = Channel.new
      u = User.new "Something"
      c.add u
      c.contains?(u).should be_true
    end

  end
end
