require 'spec_helper'
require 'time'

describe Rstk::YamlList do
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
end
