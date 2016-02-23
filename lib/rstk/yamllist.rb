# encoding: utf-8
module Rstk
  TASK_FILE = "/home/hilolih/GTD/task.yml"
  class YamlList < List
    def initialize(path=TASK_FILE)
      @tasks = nil
      @path = path
      open( @path, "r"){|f|
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

    def update new
      super(new)
    end

    def delete deltask
      super(deltask)
    end


    def has_task? id
      @tasks.any?{|t| t["id"] == id}
    end

    def query opt
      @tasks.select!{|t| 
        opt.all?{|k,v|
          v == t[k]
        }
      }
      self
    end

    def task id
      r = Regexp.new(id)
      task = @tasks.select{|t| r.match(t["id"])}
      if task.nil? or not task.one?
        raise Rstk::Error::IdError
      end
      task.first
    end

    def add task
      default_task = {
        "id" => ::SecureRandom.hex,
        "category" => nil,
        "done" => false,
        "create_time" => Time.now.strftime("%Y/%m/%d %H:%M:%S"),
        "due-date" => nil,
        "kaisya" => true,
      }
      @tasks << default_task.merge(task)
      commit
      # puts @tasks
    end

    def commit
      # puts @tasks.to_yaml
      open( @path, "w"){|f|
        f.puts @tasks.to_yaml
      }
    end
  end
end
