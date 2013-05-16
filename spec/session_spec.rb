require 'spec_helper'

module EventMachineMOM 
  describe Session do

    it 'stores session messages' do
      Session.create name: 'dummy_session', text: 'dummy_text'
      Session.exists?(name: 'dummy_text').should be_true
    end

  end
end
