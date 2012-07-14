require './lib/env.rb'
require './lib/parser.rb'

module Lispr
  @@parser = Parser.new

  def run s
    @@parser.run s
  end

  def read s
    @@parser.read s
  end

  def repl
   @@parser.repl
  end
end
