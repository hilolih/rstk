# encoding: utf-8
module Rstk
  class List
    include Enumerable
    attr_accessor :tasks
    def initialize; end

    def read; end

    def query; end

    def add
    end

    def update new
      raise Rstk::Error::IdError unless new.has_key?('id')
      old = task( new['id'] )
      update_task = old.merge(new)
      # 時間の更新
      update_task = update_task.merge({
        "update_time" => Time.now.strftime("%Y/%m/%d %H:%M:%S")
      })
      @tasks.map!{|t|
        t['id'] == update_task['id'] ? update_task : t
      }
      commit
      return update_task
    end

    def delete deltask
      raise Rstk::Error::IdError unless deltask.has_key?('id')
      deltask = task( deltask['id'] )
      @tasks.delete_if{|t| t["id"] == deltask['id'] }
      commit
      return deltask
    end
  end
end

