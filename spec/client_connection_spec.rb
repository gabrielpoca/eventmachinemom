require 'spec_helper'

describe '#connection' do

  it 'accepts a connection' do
    conn = Custom::WebSocket.new("ws://localhost:8080")
    conn.send "Hello"
    conn.close
  end

end

