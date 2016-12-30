# encoding: utf-8
module Rstk
  class Task
    def initialize(path="")
      if path == ""
        @list = YamlList.new
      else
        @list = YamlList.new(path)
      end
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

    # タスク一覧を表示
    def where opt={"done" => false}
      puts format_list(opt).join("\n")
    end

    # 整形したタスク一覧の配列
    def format_list opt
      @list.where(opt).map{|l| format(l) }
    end

    # 各タスクを１行に整形する
    def format line
      done     = line["done"] ? "[x]" : "[*]"
      category = "[%12s]" % [ line["category"] ]
      task_age = "[%3s]" % [ age(line["create_time"]) ]
      duedate  = ""
      if (line["category"] == 'calendar') and line["due-date"]
        duedate = "(" + line["due-date"] + ")"
      end
      return "#{done} #{line['id'][0,6]} #{category} #{task_age} #{line['name']} #{duedate}"
    end

    def add_from_cmdline task
      category_check task
      @list.add task
      msg = "[*] タスク登録しました: #{task['name']}"
      Rstk::Slack.send(msg)
    end

    def edit id
      old = @list.task id
      # Editorを起動してタスク登録
      temp = create_temp( old )
      Rstk::Editor::Vim.new.open( temp.path )
      task = Psych.load( open( temp.path, "r" ).read )
      if old == task
        puts "[*] 中断します: #{task['name']}"
      else
        #
        category_check task
        name_check task
        done_check task
        kaisya_check task
        task = @list.update( task )
        msg = "[*] タスク変更しました: #{task['name']}"
        puts msg
        Rstk::Slack.send(msg)
      end
    end

    def edit_all opt={"done" => false}
      # Editorを起動してタスク登録
      temp = create_temp(format_list(opt))
      puts temp.path
      Rstk::Editor::Vim.new.open( temp.path )
    end

    def add
      # Editorを起動してタスク登録
      comment = "# due-date: yyyy/mm/dd\n"
      temp = create_temp({ "name" => "", "category" => "", "kaisya" => true, }, comment)
      Rstk::Editor::Vim.new.open( temp.path )
      task = Psych.load( open( temp.path, "r" ).read )
      # 
      category_check task
      name_check task
      @list.add task
      msg = "[*] タスク登録しました: #{task['name']}"
      puts msg
      Rstk::Slack.send(msg)
    end

    def delete id
      task = @list.delete({"id" => id})
      puts "[*] タスク削除しました: #{task['name']}"
    end

    def category_check opt
      # categoryに未定義の単語を入れさせない(空はOK）
      if opt.has_key?("category") and
        not opt["category"].nil? and
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

    def done_check opt
      if not opt.has_key?("done") or 
        (opt["done"].to_s != "true" and opt["done"].to_s != "false" )
        raise Rstk::Error::DoneError
      end
      true
    end

    def kaisya_check opt
      if not opt.has_key?("kaisya") or 
        (opt["kaisya"].to_s != "true" and opt["kaisya"].to_s != "false" )
        raise Rstk::Error::KaisyaError
      end
      true
    end

    def age createtime
      date = Date.strptime(createtime, '%Y/%m/%d')
      (Date.today - date).to_i
    end    

    private 

    def create_temp(obj, comment="")
      temp = ::Tempfile.new("rstk")
      if obj.class == Hash
        temp.puts obj.to_yaml
      elsif obj.class == Array
        temp.puts obj.join("\n")
      end
      temp.puts comment
      temp.close
      return temp
    end
  end
end
