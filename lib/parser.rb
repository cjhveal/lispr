module Lispr
  class Parser
    attr_accessor :global_env

    def initialize env=Env.new
      @global_env = env
    end

    def run x, env=@global_env
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
        print "lispr> "
        val = run read gets.chomp
        puts "=> #{val}" unless val.nil?
      end
    end
  end
end