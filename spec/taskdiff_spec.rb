require 'spec_helper'

describe Rstk::TaskDiff do
  before(:each) do
    @before = ::Tempfile.new("before")
    edit_before = <<EOF
[*] cfe169 [ next action] [324] DockerコンテナでMQ
[*] e28c51 [ next action] [324] DockerコンテナでDB2
EOF
    @before.puts edit_before
    @before.close
  end

  it "変化なしファイルを比較" do
    after = ::Tempfile.new("after")
    edit_after = <<EOF
[*] cfe169 [ next action] [324] DockerコンテナでMQ
[*] e28c51 [ next action] [324] DockerコンテナでDB2
EOF
    after.puts edit_after
    after.close
    taskdiff = Rstk::TaskDiff.new(@before.path, after.path)
    expect( taskdiff.actions() ).to eq([]) 
  end

  it "タスクをひとつ削除" do
    after = ::Tempfile.new("after")
    edit_after = <<EOF
[*] cfe169 [ next action] [324] DockerコンテナでMQ
EOF
    after.puts edit_after
    after.close
    taskdiff = Rstk::TaskDiff.new(@before.path, after.path)
    expect( taskdiff.actions() ).to eq([{ "method" => "delete", "id" => "e28c51"} ]) 
  end
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
