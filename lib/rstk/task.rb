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
      return "#{done} #{line['id'][0,6]} #{category} #{line['name']} #{duedate}"
    end

    def add_from_cmdline task
      category_check task
      @list.add task
    end

    def edit id
      p @list.task id
    end

    def add
      temp = ::Tempfile.new("rstk")
      template = {
        "name" => "",
        "category" => "",
        "kaisya" => true,
      }
      temp.puts template.to_yaml
      temp.close
      # Editorを起動してタスク登録
      Rstk::Editor::Vim.new.open( temp.path )
      task = Psych.load( open( temp.path, "r" ).read )
      # 
      category_check task
      name_check task
      @list.add task
      puts "[*] タスク登録しました: #{task['name']}"
    end

    def delete id
      # 既存のidかチェック
      unless @list.has_only_task?(id)
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
