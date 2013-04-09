require 'lispr/env'
require 'lispr/parser'

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
