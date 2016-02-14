# encoding: utf-8
module Rstk
  class Task
    def initialize
      @list = YamlList.new
      # puts @tasks[0]["name"].encode("sjis")
    rescue => e
      puts e
    end

    def show opt={"done" => false}
      p opt
      @list.query(opt).each do |l|
        puts format(l)
      end
    end

    def format line
      done = line["done"] ? "[x]" : "[*]"
      category = "[%12s]" % [ line["category"] ]
      return "#{done} #{category} #{line['name']}"
    end

    def add_from_cmdline task
      @list.add task
    end

  end
end