require 'spec_helper'

describe Textpow::SyntaxNode do
  before do
    Textpow::SyntaxNode.send(:class_variable_set, "@@syntaxes", {})
  end

  describe "#load" do
    it "can load from xml .plist" do
      Textpow::SyntaxNode.load('spec/fixtures/objeck.plist').should_not == nil
    end

    it "can load from yaml .syntax" do
      Textpow::SyntaxNode.load('lib/textpow/syntax/ruby.syntax').should_not == nil
    end

    it "cannot load missing file" do
      lambda{
        Textpow::SyntaxNode.load('xxx.syntax')
      }.should raise_error
    end

    it "cannot load missing plist file" do
      lambda{
        Textpow::SyntaxNode.load('xxx.plist')
      }.should raise_error
    end
  end

  describe "#new" do
    it "loads strings from given hash" do
      syntax = Textpow::SyntaxNode.new('content' => 'CONTENT', 'name' => 'NAME')
      syntax.content.should == 'CONTENT'
      syntax.name.should == 'NAME'
    end

    it "loads regex from given hash" do
      syntax = Textpow::SyntaxNode.new('firstLineMatch' => 'aaa', 'foldingStartMarker' => 'bbb')
      syntax.firstLineMatch.inspect.should == "/aaa/"
      syntax.foldingStartMarker.inspect.should == "/bbb/"
    end

    it "raises ParsingError on invalid regex" do
      lambda{
        Textpow::SyntaxNode.new('firstLineMatch' => '$?)(:[/\]')
      }.should raise_error(Textpow::ParsingError)
    end

    it "stores itself as parent" do
      node = Textpow::SyntaxNode.new({})
      node.syntax.should == node
    end

    it "stores given parent" do
      node = Textpow::SyntaxNode.new({}, 1)
      node.syntax.should == 1
    end

    it "stores itself in global namespace under scopeName" do
      node = Textpow::SyntaxNode.new("scopeName" => 'xxx')
      node.syntaxes['xxx'].should == node
      Textpow::SyntaxNode.new({}).syntaxes['xxx'].should == node
    end

    it "stores itself in scoped global namespace under scopeName" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx'}, nil, 'foo')
      node.syntaxes['xxx'].should == node
      Textpow::SyntaxNode.new({},nil,'foo').syntaxes['xxx'].should == node
      Textpow::SyntaxNode.new({}).syntaxes['xxx'].should == nil
    end
  end

  describe "#parse" do
    let(:node){ Textpow.syntax('ruby') }

    it "uses a RecordingProcessor by default" do
      node.parse("111").stack.should == [
        [:start_parsing, "source.ruby"],
        [:new_line, "111"],
        [:open_tag, "constant.numeric.ruby", 0],
        [:close_tag, "constant.numeric.ruby", 3],
        [:end_parsing, "source.ruby"]
      ]
    end

    it "can parse with a processor" do
      processor = Textpow::RecordingProcessor.new
      processor.stack << 'xxx'
      node.parse("111", processor).stack.should == [
        "xxx",
        [:start_parsing, "source.ruby"],
        [:new_line, "111"],
        [:open_tag, "constant.numeric.ruby", 0],
        [:close_tag, "constant.numeric.ruby", 3],
        [:end_parsing, "source.ruby"]
      ]
    end

    it "can parse multiline syntax via stack" do
      node.parse("=begin\n111\n=end").stack.should == [
        [:start_parsing, "source.ruby"],
        [:new_line, "=begin\n"],
        [:open_tag, "comment.block.documentation.ruby", 0],
        [:open_tag, "punctuation.definition.comment.ruby", 0],
        [:close_tag, "punctuation.definition.comment.ruby", 6],
        [:new_line, "111\n"],
        [:new_line, "=end"],
        [:open_tag, "punctuation.definition.comment.ruby", 0],
        [:close_tag, "punctuation.definition.comment.ruby", 4],
        [:close_tag, "comment.block.documentation.ruby", 4],
        [:end_parsing, "source.ruby"]
      ]
    end

    it "loads included syntax files" do
      pending
      node = Textpow.syntax('html_rails')
      node.parse("<br/>")
    end
  end

  describe "#match_first_son" do
    it "returns nil when patterns are empty" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx'})
      node.send(:match_first_son, "xxx", 0).should == nil
    end

    it "matches a pattern" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx', 'patterns' => [
        {"match" => "xxx", "name" => "foo"}
      ]})
      pattern, match = node.send(:match_first_son, "xxxyy", 0)
      match.to_s.should == 'xxx'
      pattern.name.should == 'foo'
    end

    it "matches the first pattern" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx', 'patterns' => [
        {"match" => "yyy", "name" => "bar"},
        {"match" => "xxx", "name" => "foo"},
        {"match" => "zzz", "name" => "baz"},
      ]})
      pattern, match = node.send(:match_first_son, "xxxyyyzzz", 0)
      match.to_s.should == 'xxx'
      pattern.name.should == 'foo'
    end

    it "matches the first pattern for equal positions" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx', 'patterns' => [
        {"match" => "xxx", "name" => "bar"},
        {"match" => "xxxyyy", "name" => "foo"},
        {"match" => "xxxyy", "name" => "baz"},
      ]})
      pattern, match = node.send(:match_first_son, "xxxyyyzzz", 0)
      match.to_s.should == 'xxx'
      pattern.name.should == 'bar'
    end
  end

  describe "proxying" do
    it "cannot proxy by scopeName if syntax is missing" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx', 'patterns' => [{'include' => 'foo'}]})
      node.parse('bar').stack.should == [
        [:start_parsing, "xxx"],
        [:new_line, "bar"],
        [:end_parsing, "xxx"]
      ]
    end

    it "can proxy by scopeName if syntax is defined (even later)" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx', 'patterns' => [{'include' => 'foo'}]})
      Textpow::SyntaxNode.new({"scopeName" => 'foo', 'patterns' => [{'name' => 'foo.1', 'match' => 'bar'}]})
      node.parse('bar').stack.should == [
        [:start_parsing, "xxx"],
        [:new_line, "bar"],
        [:open_tag, "foo.1", 0],
        [:close_tag, "foo.1", 3],
        [:end_parsing, "xxx"]
      ]
    end

    it "can proxy to a pattern defined in an repository" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx',
        'repository' => {'foo' => {'name' => 'foo.1', 'match' => 'bar'}},
        'patterns' => [{'include' => '#foo'}]
      })
      node.parse('bar').stack.should == [
        [:start_parsing, "xxx"],
        [:new_line, "bar"],
        [:open_tag, "foo.1", 0],
        [:close_tag, "foo.1", 3],
        [:end_parsing, "xxx"]
      ]
    end

    it "can proxy to a pattern nested included in an repository" do
      node = Textpow::SyntaxNode.new({"scopeName" => 'xxx',
        'repository' => {
          'baz' => {'patterns' => [{'include' => '#foo'}]},
          'foo' => {'name' => 'foo.1', 'match' => 'bar'}
        },
        'patterns' => [{'include' => '#baz'}]
      })
      node.parse('bar').stack.should == [
        [:start_parsing, "xxx"],
        [:new_line, "bar"],
        [:open_tag, "foo.1", 0],
        [:close_tag, "foo.1", 3],
        [:end_parsing, "xxx"]
      ]
    end
  end
end
