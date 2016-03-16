module Rstk

  class CommandTransform < Parslet::Transform
  end

  class SampleParser < Parslet::Parser
    rule(:integer) { match('[0-9]').repeat(1) >> space? }
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    rule(:operator)   { match('[+]') >> space? }
   
    rule(:sum)        { integer >> operator >> expression }
    rule(:expression) { sum | integer }

    root :expression
  end
end

