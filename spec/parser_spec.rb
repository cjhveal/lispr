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

    it "should wrap tokens in lists" do
      parser.read_next(%w/( a b c )/).should == [:a, :b, :c]
    end

    it "should nest lists" do
      parser.read_next(%w/( ( a b ) c )/).should eq [[:a, :b], :c]
    end

    it "should atomize bare tokens" do
      parser.read_next(['1']).should == 1
      parser.read_next(['1.1']).should == 1.1
      parser.read_next(['atom']).should == :atom
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

  describe :run do
    it "should evaluate arithmetic" do
      parser.run([:+, 1, 1]).should eq 2
      parser.run([:-, 2, 1]).should eq 1
      parser.run([:*, 2, 2]).should eq 4
      parser.run([:/, 4, 2]).should eq 2
    end
  end
end
