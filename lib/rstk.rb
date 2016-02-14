require "rstk/version"
require "psych"

module Rstk
  require "rstk/task"
  require "rstk/list"
  require "rstk/yamllist"
end

task = Rstk::Task.new
# task.add_from_cmdline({"name"=> "add test"})
# task.show({})
task.show()
