require 'spec_helper'
require './lib/wrapper'
require 'json'
require 'msgpack'

class Module
  def redefine_const(name, value)
    __send__(:remove_const, name) if const_defined?(name)
    const_set(name, value)
  end
end

class TestClass
  include Wrapper
end

describe Wrapper do
  let(:msg) do
    { 'foo' => 'bar', 'baz' => 5, 'a' => [3,5,4]} 
  end
  context 'json' do
    let(:tester) { TestClass.new }
    it "should call to_json on the message" do
      msg.expects(:to_json)
      tester.pack msg
    end
    it "should call JSON.parse on the message" do
      json = msg.to_json
      JSON.expects(:parse).with(json)
      tester.unpack json
    end
    it "should keep the msg unchanged when packing and unpacking" do
      tester.unpack(tester.pack(msg)).should eq(msg)
    end
  end
  context 'msgpack' do
    before :all do
      Object.redefine_const(:JSON,nil) #remove JSON to test MessagePack
    end
    let(:tester) { TestClass.new }
    it "should call to_msgpack on the message" do
      msg.expects(:to_msgpack)
      tester.pack msg
    end
    it "should call MessagePack.unpack on the message" do
      msgpk = msg.to_msgpack
      MessagePack.expects(:unpack).with(msgpk)
      tester.unpack msgpk
    end
    it "should keep the msg unchanged when packing and unpacking" do
      tester.unpack(tester.pack(msg)).should eq(msg)
    end
  end
end