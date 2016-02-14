# encoding: utf-8
module Rstk
  TASK_FILE = "./task.yml"
  class YamlList < List
    def initialize
      @tasks = nil
      open( TASK_FILE, "r"){|f|
        ast = Psych.parse f.read
        @tasks = ast.to_ruby
      }
      puts @tasks[0]["name"].encode("sjis")
    end

    def read
    end

    def query
    end
  end
end
