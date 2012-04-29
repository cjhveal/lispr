require './lib/env.rb'
require './lib/parser.rb'

module Lispr
  GLOBALS = {:+ => lambda(&:+), :- => lambda(&:-), :* => lambda(&:*), :/ => lambda(&:/), :% => lambda(&:%),
             :not => lambda(&:!), :> => lambda(&:>), :< => lambda(&:<), :>= => lambda(&:>=), :<= => lambda(&:<=),
             :== =>lambda(&:==), :equal? => lambda(&:==), :eq? => lambda(&:===), :length => lambda(&:length),
             :cons => lambda{|x,y| y.unshift x }, :car => lambda(&:first), :cdr => lambda{|x| x[1..-1]},
             :append => lambda(&:<<), :list => lambda{|*x| x}, :list? => lambda{|x| x.class == Array},
             :null => lambda(&:empty?), :symbol? => lambda{|x| x.class == Symbol}, :or => lambda{|*x| x.any?},
             :and => lambda{|*x| x.all?}}
  @@parser = Parser.new Env.new GLOBALS

  def run s
    @@parser.run s
  end

  def read s
    @@parser.read_next @@parser.tokenize s
  end

  def repl
    loop do
      print "lispr> "
      val = run read gets.chomp
      puts "=> #{val}" unless val.nil?
    end
  end
end
