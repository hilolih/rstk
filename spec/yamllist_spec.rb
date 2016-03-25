require 'spec_helper'
require 'time'

describe Rstk::YamlList do
  before(:each) do
    @temp = ::Tempfile.new("task")
    @template = [{
      "id"  => "abcdefg",
      "name" => "test1",
      "category" => "waiting",
      "kaisya" => true,
      "done" => false
     },
     {
      "id"  => "1234567",
      "name" => "test2",
      "category" => "calendar",
      "due-date" => "2016/02/24",
      "kaisya" => false,
      "done" => false
     },
     {
      "id"  => "1234567a",
      "name" => "test3",
      "category" => "calendar",
      "kaisya" => false,
      "update_time" => "2016/02/24 12:00:00",
      "done" => false
    }]
    @temp.puts @template.to_yaml
    @temp.close
    @list = Rstk::YamlList.new(@temp.path)
  end

  it 'update test1 from undone to done' do
    # Time.nowのスタブ
    allow(Time).to receive_message_chain(:now).and_return(Time.mktime(1981,1,21,12,12,12))
    got = @list.update({
      "id" => "abcdefg",
      "done" => true,
    })
    expect(got).to eq({
      "id"  => "abcdefg",
      "name" => "test1",
      "category" => "waiting",
      "kaisya" => true,
      "done" => true,
      "update_time" => "1981/01/21 12:12:12"
    })
  end

  it 'update task has not id so that IdError' do
    expect { @list.update({ "done" => true, }) }.to raise_error(Rstk::Error::IdError)
  end

  it 'update undefined id so that IdError' do
    expect { 
      @list.update({ "id" => "hogehoge", "done" => true, }) 
    }.to raise_error(Rstk::Error::IdError)
  end

  it 'delete task has not id so that IdError' do
    expect { 
      @list.delete({ "id" => "hogehoge", "done" => true, }) 
    }.to raise_error(Rstk::Error::IdError)
  end

  it 'where empty condition returns to all lists' do
    expect( @list.where({}).length).to eq( @template.length ) 
  end

  it 'where never match id returns to nothing' do
    expect( @list.where({"id" => "never_match_id"}).length).to eq(0) 
  end

  it 'where match one id returns to only one task' do
    expect( @list.where({"id" => "1234567a"}).length).to eq(1) 
  end

  it 'takes id and done (AND CONDITION)' do
    expect( @list.where({"id" => "1234567a", "done" => false }).length).to eq(1) 
  end

  it 'takes id list returns to match tasks' do
    expect( @list.where({"id" => ["1234567a",  "abcdefg"]}).length).to eq(2) 
  end

  it 'complex condition no 1' do
    expect( @list.where({
      "id"   => ["1234567a",  "abcdefg"], 
      "name" => "test1"}).length
    ).to eq(1) 
  end

  it 'complex condition no 2' do
    expect( @list.where([
      {"id"   => ["1234567a",  "abcdefg"]},
      {"name" => "test1"}
    ]).length).to eq(2) 
  end

  it 'where before due-date returns to 1 task' do
    # due-date is 2016/02/24
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2016,2,25))
    expect( @list.where({"due-date" => {:before => "Today"}}).length).to eq(1) 
  end

  it 'where before due-date returns to 1 task(due-date = today)' do
    # due-date is 2016/02/24
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2016,2,24))
    expect( @list.where({"due-date" => {:before => "Today"}}).length).to eq(1) 
  end

  it 'where before due-date returns to 0 task' do
    # due-date is 2016/02/24
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2016,2,23))
    expect( @list.where({"due-date" => {:before => "Today"}}).length).to eq(0) 
  end

  it 'check_due_date return true' do
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2015,1,2))
    expect( @list.check_due_date("2015/01/01", {:before => "Today"}) ).to be true 
  end

  it 'check_due_date return true' do
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2015,1,1))
    expect( @list.check_due_date("2015/01/01", {:before => "Today"}) ).to be true 
  end

  it 'check_due_date return false' do
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2014,12,31))
    expect( @list.check_due_date("2015/01/01", {:before => "Today"}) ).to be false 
  end

  it 'check_due_date between today and tommorow' do
    allow(Date).to receive_message_chain(:today).and_return(Date.new(2014,12,31))
    expect( @list.check_due_date("2015/01/01", {:after => "Today", :before => "Tomorrow"}) ).to be true 
  end

end
