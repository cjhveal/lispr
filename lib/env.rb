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
end
