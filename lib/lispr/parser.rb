module Lispr
  class Parser
    attr_accessor :global_env

    GLOBALS = {:+ => lambda(&:+), :- => lambda(&:-), :* => lambda(&:*), :/ => lambda(&:/), :% => lambda(&:%),
               :not => lambda(&:!), :> => lambda(&:>), :< => lambda(&:<), :>= => lambda(&:>=), :<= => lambda(&:<=),
               :== =>lambda(&:==), :equal? => lambda(&:==), :eq? => lambda(&:===), :length => lambda(&:length),
               :cons => lambda{|x,y| y.unshift x }, :car => lambda(&:first), :cdr => lambda{|x| x[1..-1]},
               :append => lambda(&:<<), :list => lambda{|*x| x}, :list? => lambda{|x| x.class == Array},
               :null => lambda(&:empty?), :symbol? => lambda{|x| x.class == Symbol}, :or => lambda{|*x| x.any?},
               :and => lambda{|*x| x.all?}}

    def initialize env=Env.new(GLOBALS)
      @global_env = env
    end

    def run x, env=@global_env
      return env.find x if x.kind_of? Symbol
      return x unless x.kind_of? Array

      case procedure = x.shift
      when :quote
        return x
      when :if
        (test, conseq, alt) = x
        run (run(test,env) ? conseq : alt), env
      when :set!
        (var, expr) = x
        env.set! var, run(expr,env)
      when :define
        (var, expr) = x
        env.define var, run(expr,env)
      when :lambda
        (params, expr) = x
        lambda { |*args| run expr, (Env.new Hash[params.zip args], env) }
      when :begin
        x.map {|expr| run expr, env}.last
      else
        exprs = x.map {|expr| run expr, env}
        env.find(procedure).call(*exprs)
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
  end
end
