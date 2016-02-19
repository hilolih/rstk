# encoding: utf-8
module Rstk
  class Editor::Vim
    def initialize
      @editor = "vim"
    end

    def open( path )
      # 2行目、８カラム目でvimを起動
      option = "-c \"call cursor(2,8)\""
      cmd = "</dev/tty >/dev/tty #{@editor} #{option} #{path}"
      status, stdout, stderr = systemu cmd
    end
  end
end

