module Rstk

  class CommandParser < Parslet::Parser
    #rule(:object)  { any.repeat >> space? }
    rule(:space)   { match('\s').repeat(1) }
    rule(:space?)  { space.maybe }

    rule(:categories){ (str('NextAction') | 
                        str('Project')    | 
                        str('Someday')    |
                        str('Calendar')   |
                        str('Waiting')).as(:category) >> space? }

    rule(:operator)   { match('[=]') >> space? }
   
    rule(:keyword) { str("'") >> match("[^']").repeat(1).as(:keyword) >> str("'") >> space? }

    rule(:expression){ categories >> operator >> keyword }

    root :expression
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

