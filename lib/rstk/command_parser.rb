module Rstk

  class CommandParser < Parslet::Parser
    #rule(:object)  { any.repeat >> space? }
    rule(:space)   { match('\s').repeat(1) }
    rule(:space?)  { space.maybe }

    rule(:categories){ (str('NextAction') | 
                        str('Project')    | 
                        str('Someday')    |
                        str('Calendar')   |
                        str('Waiting')).as(:left) >> space? }

    rule(:operator)   { match('[=]').as(:op) >> space? }

    rule(:logical)   { str('and') >> space? }
   
    rule(:keyword) { str("'") >> match("[^']").repeat(1).as(:right) >> str("'") >> space? }

    rule(:expr){ categories >> operator >> keyword }

    rule(:expression){ ( expr >> logical | expr ).repeat.as(:expr) }

    root :expression
  end

end

