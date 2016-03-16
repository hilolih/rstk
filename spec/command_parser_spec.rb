require 'spec_helper'

def parse(s)
  Rstk::CommandParser.new.parse(s)
end


describe Rstk::CommandParser do
  it 'basic' do
    expect(parse("NextAction = 'ああ'")).to eq({:category => "NextAction",  :keyword => "ああ"})
  end

  it 'and logic' do
    expect(parse("NextAction = 'ああ' and Waiting = 'true' ")).to eq(9)
  end
end
