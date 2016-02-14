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
      # puts @tasks[0]["name"].encode("sjis")
    end

    def each
      @tasks.each do |task|
        yield task
      end
    end

    def read
    end

    def query opt
      @tasks.select!{|t| 
        opt.all?{|k,v|
          v == t[k]
        }
      }
      self
    end

    def add task
      default_task = {
        "id" => Time.now.strftime("%Y%m%d%H%M%S").to_i,
        "category" => nil,
        "done" => false,
        "datetime" => Time.now.strftime("%Y/%m/%d %H:%M:%S"),
        "due-date" => nil,
      }
      @tasks << default_task.merge(task)
      commit
      # puts @tasks
    end

    def commit
      # puts @tasks.to_yaml
      open( TASK_FILE, "w"){|f|
        f.puts @tasks.to_yaml
      }
    end
  end
end
