describe Parser do
  let(:parser) { Parser.new }
  describe :tokenize do
    it "should break tokens up by whitespace" do
      parser.tokenize("abc d e").should eq %w(abc d e)
    end

    it "should tokenize all parentheses" do
      parser.tokenize("((abc))").should eq %w/( ( abc ) )/
    end
  end

  describe :read_next do
    it "should error on unmatched parentheses" do
     lambda { parser.read_next %w/ ) ( a ) / }.should raise_error
     lambda { parser.read_next %w/ ( ( a ) / }.should raise_error
    end

    it "should nest lists" do
      parser.read_next(%w/( ( a b ) c )/).should eq [[:a, :b], :c]
    end
  end

  describe :atomize do
    it "should convert to integer" do
      n = parser.atomize "1"
      n.class.should eq Fixnum
      n.should eq 1
    end

    it "should convert to float" do 
      n = parser.atomize "1.1"
      n.class.should eq Float
      n.should eq 1.1
    end

    it "should convert to symbol for all else" do
      x = parser.atomize "abc"
      x.class.should eq Symbol
      x.should eq :abc
    end
  end
end
