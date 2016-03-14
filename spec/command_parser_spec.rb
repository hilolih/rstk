require 'spec_helper'

def parse(s)
  Rstk::CommandParser.new.parse(s)
end

def parse_sample(s)
  Rstk::SampleParser.new.parse(s)
end

describe Rstk::CommandParser do
  it 'sample basic' do
    expect(parse_sample("11 + 1")).to eq("11 + 1")
  end
  it 'basic' do
    expect(parse("NextAction = 'ああ'")).to eq("NextAction = 'ああ'")
  end
end
