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
      category_check opt
      @list.query(opt).each do |l|
        puts format(l)
      end
    end

    def format line
      done = line["done"] ? "[x]" : "[*]"
      category = "[%12s]" % [ line["category"] ]
      duedate = ""
      if (line["category"] == 'calendar') and line["due-date"]
        duedate = "(" + line["due-date"] + ")"
      end
      return "#{done} #{category} #{line['name']} #{duedate}"
    end

    def add_from_cmdline task
      category_check task
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
      # 2行目、８カラム目でvimを起動
      option = "-c \"call cursor(2,8)\""
      cmd = "</dev/tty >/dev/tty #{ENV['EDITOR']} #{option} #{temp.path}"
      status, stdout, stderr = systemu cmd
      task = Psych.load( open( temp.path, "r" ).read )
      # 
      category_check task
      name_check task
      @list.add task
      puts "[*] タスク登録しました: #{task['name']}"
      # if task['name'] != ""
      # else
      #   raise Rstk::Error::IdError
      # end

    end

    def delete id
      # 既存のidかチェック
      unless @list.has_task?(id)
        raise Rstk::Error::IdError
      end
      @list.delete(id)
    end

    private

    def category_check opt
      # categoryに未定義の単語を入れさせない(空はOK）
      if opt.has_key?("category") and
        opt["category"] != "" and
        not Categories::List.include?( opt["category"] )
        raise Rstk::Error::CategoriesError
      end
    end

    def name_check opt
      if not opt.has_key?("name") or (opt["name"] == "")
        raise Rstk::Error::NameError
      end
    end

  end
end
