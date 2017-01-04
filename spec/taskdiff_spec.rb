require 'spec_helper'

describe Rstk::TaskDiff do
  before(:each) do
    @temp = ::Tempfile.new("task")
    edit_before = <<EOF
[*] cfe169 [ next action] [324] DockerコンテナでMQ
[*] e28c51 [ next action] [324] DockerコンテナでDB2
EOF
    @temp.puts edit_before
    @temp.close
  end

  #it "" do
  #  @task = Rstk::TaskDiff.new(@temp.path)
  #end

  #it 'raise DoneError invalid name on done_check' do
  #  expect {
  #    @task.done_check({ "done" => "hoge" })
  #  }.to raise_error(Rstk::Error::DoneError)
  #end

  #it 'Age表示。昨日のタスクは１である' do
  #  allow(Date).to receive_message_chain(:today).and_return(Date.new(2015,12,31))
  #  expect( @task.age( "2015/12/30 00:38:18" ) ).to eq(1) 
  #end
end
