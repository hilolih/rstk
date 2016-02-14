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
      # categoryに未定義の単語を入れさせない(空はOK）
      if task.has_key?("category") and  not Categories::List.include?( task["category"] )
        raise Rstk::Error::CategoriesError
      end
      @list.add task
    end

    def add
      temp = ::Tempfile.new("rstk")
      template = {
        "name" => "",
        "category" => "",
      }
      temp.puts template.to_yaml
      temp.close
      #
      cmd = "</dev/tty >/dev/tty #{ENV['EDITOR']} #{temp.path}"
      status, stdout, stderr = systemu cmd
      task = Psych.load( open( temp.path, "r" ).read )
      if task['name'] != ""
        @list.add task
        puts "[*] タスク登録しました: #{task['name']}"
      else
        raise Rstk::Error::IdError
      end

    end

    def delete id
      # 既存のidかチェック
      unless @list.has_task?(id)
        raise Rstk::Error::IdError
      end
      @list.delete(id)
    end

  end
end
