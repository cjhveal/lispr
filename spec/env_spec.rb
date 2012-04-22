require 'rspec'

require './lispr.rb'
include Lispr

describe Env do
  before(:each) do
    @env = Env.new
    @env.define :x, 1
  end

  it 'should not define a defined symbol' do
    lambda { @env.define(:x, 1) }.should raise_error
  end

  it 'should find a defined symbol' do
    @env.find(:x).should eq 1
  end

  it 'should not find undefined symbols' do
    lambda { @env.find(:y) }.should raise_error
  end

  it 'should set a defined symbol' do
    @env.set! :x, 2
    @env.find(:x).should eq 2
  end

  it 'should not set an undefined symbol' do
    lambda { @env.set!(:y, 1) }.should raise_error
  end
end
