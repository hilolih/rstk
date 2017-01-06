# encoding: utf-8
require 'diff-lcs'
#
# Rstk::TaskDiff
#
# --editオプションでエディタを開いて編集したタスクの新旧比較
#
module Rstk
  class TaskDiff
    def initialize( before_path, after_path )
      @before = IO.readlines( before_path )
      @after  = IO.readlines( after_path )
    end

    def actions
      sdiff = Diff::LCS.sdiff( @before, @after )
      re    = sdiff.select{|ary| ary.to_a[0] != "="}
      return re
    end
  end
end

