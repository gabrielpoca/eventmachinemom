require 'spec_helper'

describe '#connection' do

  it 'accepts a connection' do
    conn = Custom::WebSocket.new "ws://localhost:8080"
    conn.close
  end

  it 'accepts multiple connections' do
    conn_1 = Custom::WebSocket.new "ws://localhost:8080"
    conn_2 = Custom::WebSocket.new "ws://localhost:8080"
    [conn_1, conn_2].map &:close
  end

  it 'broadcasts a channel' do
    conn_1 = Custom::WebSocket.new "ws://localhost:8080"
    conn_1.receive
    conn_2 = Custom::WebSocket.new "ws://localhost:8080"
    [conn_1, conn_2].map &:close
  end
end

