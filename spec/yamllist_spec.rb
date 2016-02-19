require 'spec_helper'

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
    got = @list.update({
      "id" => "abcdefg",
      "done" => true,
    })
    expect(got).to eq({
      "id"  => "abcdefg",
      "name" => "test1",
      "category" => "waiting",
      "kaisya" => true,
      "done" => true
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
end
