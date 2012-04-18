module Lispr
  class Env
    attr_reader :dict, :outer
    def initialize vals=Hash.new, outer = nil
      @dict = vals
      @outer = outer
    end

    def define var, val
      raise "Symbol '#{var}' already defined as #{@dict[var]}" if @dict.has_key? var
      @dict[var] = val
    end

    def set! var, val
      raise "Symbol '#{var}' not defined" unless @dict.has_key? var
      @dict[var] = val
    end

    def find var
      return @dict[var] if @dict.has_key? var
      @outer.find var rescue raise "Symbol '#{var}' not defined"
    end
  end
  GLOBALS = {:+ => lambda(&:+), :- => lambda(&:-), :* => lambda(&:*), :/ => lambda(&:/), :% => lambda(&:%),
             :not => lambda(&:!), :> => lambda(&:>), :< => lambda(&:<), :>= => lambda(&:>=), :<= => lambda(&:<=),
             :== =>lambda(&:==), :equal? => lambda(&:==), :eq? => lambda(&:===), :length => lambda(&:length),
             :cons => lambda{|x,y| y.unshift x }, :car => lambda(&:first), :cdr => lambda{|x| x[1..-1]},
             :append => lambda(&:<<), :list => lambda{|*x| x}, :list? => lambda{|x| x.class == Array},
             :null => lambda(&:empty?), :symbol? => lambda{|x| x.class == Symbol}}
  @@global_env= Env.new GLOBALS
  
  def run x, env=@@global_env
    if x.class == Symbol
      return env.find x
    elsif x.class != Array
      return x
    elsif x.first == :quote
      return x[1..-1]
    elsif x.first == :if
      (_, test, conseq, alt) = x
      return run (run(test,env) ? conseq : alt), env
    elsif x.first == :set!
      (_, var, expr) = x
      env.set! var, run(expr,env)
    elsif x.first == :define
      (_, var, expr) = x
      env.define var, run(expr,env)
    elsif x.first == :lambda
      (_, params, expr) = x
      return lambda { |*args| run expr, (Env.new Hash[params.zip args], env) }
    elsif x.first == :begin
      x[1..-1].map {|expr| run expr, env}.last
    else
      exprs = x.map {|expr| run expr, env}
      procedure = exprs.shift
      return procedure.call(*exprs)
    end
  end

  def read s
    read_next tokenize s
  end

  def tokenize s
    s.gsub(/([\(\)])/, ' \1 ').split
  end

  def read_next tokens
    raise 'unexpected end of input' if tokens.empty?
    token = tokens.shift

    if token == '('
      branch = []
      branch.push read_next tokens until tokens.first == ')'
      tokens.shift
      return branch
    elsif token == ')' 
      raise "unexpected ')' token"
    else
      return atomize(token);
    end
  end

  def atomize token
    Integer(token) rescue Float(token) rescue token.to_sym
  end

  def repl
    loop do
      print "> "
      val = run read gets.chomp
      puts val unless val.nil?
    end
  end

end
include Lispr
