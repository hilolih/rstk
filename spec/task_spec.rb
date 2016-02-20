require 'spec_helper'

describe Rstk::Task do
  before(:each) do
    @temp = ::Tempfile.new("task")
    template = [{
      "id"  => "abcdefg",
      "name" => "test1",
      "category" => "waiting",
      "kaisya" => true,
      "done" => false},{
      "id"  => "1234567",
      "name" => "test2",
      "category" => "calendar",
      "kaisya" => false,
      "done" => false
    }]
    @temp.puts template.to_yaml
    @temp.close
    @task = Rstk::Task.new(@temp.path)
  end

  it 'raise DoneError invalid name on done_check' do
    expect {
      @task.done_check({ "done" => "hoge" })
    }.to raise_error(Rstk::Error::DoneError)
  end

  it 'raise DoneError not done defined on done_check' do
    expect {
      @task.done_check({ "hoge" => "hoge" })
    }.to raise_error(Rstk::Error::DoneError)
  end

  it 'pass done => true return true on done_check' do
    expect( @task.done_check({ "done" => true })).to be true
  end

  it 'pass done => false return true on done_check' do
    expect( @task.done_check({ "done" => false })).to be true
  end

  it 'raise DoneError invalid name on kaisya_check' do
    expect {
      @task.kaisya_check({ "kaisya" => "hoge" })
    }.to raise_error(Rstk::Error::KaisyaError)
  end

  it 'raise DoneError not kaisya defined on kaisya_check' do
    expect {
      @task.kaisya_check({ "hoge" => "hoge" })
    }.to raise_error(Rstk::Error::KaisyaError)
  end

  it 'pass kaisya => true return true on kaisya_check' do
    expect( @task.kaisya_check({ "kaisya" => true })).to be true
  end

  it 'pass kaisya => false return true on kaisya_check' do
    expect( @task.kaisya_check({ "kaisya" => false })).to be true
  end
end
