module Textpow
  RUBY_19 = (RUBY_VERSION > "1.9.0")
end
require 'oniguruma' unless Textpow::RUBY_19

module Textpow
  class SyntaxProxy
    def initialize hash, syntax
      @syntax = syntax
      @proxy = hash["include"]
    end

    def method_missing method, *args, &block
      if @proxy
        @proxy_value = proxy unless @proxy_value
        if @proxy_value
          @proxy_value.send(method, *args, &block)
        else
          STDERR.puts "Failed proxying #{@proxy}.#{method}(#{args.join(', ')})"
        end
      end
    end

    def proxy
      case @proxy
      when /^#/
        if @syntax.repository && @syntax.repository[@proxy[1..-1]]
          #puts "Repository"
          #@table["syntax"].repository.each_key{|k| puts k}
          return @syntax.repository[@proxy[1..-1]]
        end
      when "$self"
        return @syntax
      when "$base"
        return @syntax
      else
        return @syntax.syntaxes[@proxy]
      end
    end
  end

  class SyntaxNode
    @@syntaxes = {}

    attr_accessor :syntax
    attr_accessor :firstLineMatch
    attr_accessor :foldingStartMarker
    attr_accessor :foldingStopMarker
    attr_accessor :match
    attr_accessor :begin
    attr_accessor :content
    attr_accessor :fileTypes
    attr_accessor :name
    attr_accessor :contentName
    attr_accessor :end
    attr_accessor :scopeName
    attr_accessor :keyEquivalent
    attr_accessor :captures
    attr_accessor :beginCaptures
    attr_accessor :endCaptures
    attr_accessor :repository
    attr_accessor :patterns

    def self.load(file, name_space = :default)
      table = convert_file_to_table(file)
      SyntaxNode.new(table, nil, name_space)
    end

    def initialize(table, syntax = nil, name_space = :default)
      @syntax = syntax || self
      @name_space = name_space

      register_in_syntaxes(table["scopeName"])
      parse_and_store_syntax_info(table)
    end

    def syntaxes
      @@syntaxes[@name_space]
    end

    def parse(string, processor = RecordingProcessor.new)
      processor.start_parsing scopeName
      stack = [[self, nil]]
      string.each_line do |line|
        parse_line stack, line, processor
      end
      processor.end_parsing scopeName

      processor
    end

  protected

    def parse_and_store_syntax_info(table)
      table.each do |key, value|
        case key
        when "firstLineMatch", "foldingStartMarker", "foldingStopMarker", "match", "begin"
          begin
            regex = if Textpow::RUBY_19
              value.force_encoding("ASCII-8BIT")
              Regexp.new(value)
            else
              Oniguruma::ORegexp.new(value, :options => Oniguruma::OPTION_CAPTURE_GROUP)
            end
            instance_variable_set("@#{key}", regex)
          rescue ArgumentError => e
            raise ParsingError, "Parsing error in #{value}: #{e.to_s}"
          end
        when "content", "fileTypes", "name", "contentName", "end", "scopeName", "keyEquivalent"
          instance_variable_set("@#{key}", value)
        when "captures", "beginCaptures", "endCaptures"
          instance_variable_set("@#{key}", value.sort)
        when "repository"
          parse_repository value
        when "patterns"
          create_children value
        when "comment"
        else
          STDERR.puts "Ignoring: #{key} => #{value.gsub("\n", "\n>>")}" if $DEBUG
        end
      end
    end

    # register in global syntax list -> can be found by include
    def register_in_syntaxes(scope)
      @@syntaxes[@name_space] ||= {}
      @@syntaxes[@name_space][scope] = self if scope
    end

    def self.convert_file_to_table(file)
      raise "File not found: #{file}" unless File.exist?(file)

      case file
      when /(\.tmSyntax|\.plist)$/
        require 'plist'
        Plist::parse_xml(file)
      else
        YAML.load_file(file)
      end
    end

    def parse_repository repository
      @repository = {}
      repository.each do |key, value|
        if value["include"]
          @repository[key] = SyntaxProxy.new( value, self.syntax )
        else
          @repository[key] = SyntaxNode.new( value, self.syntax, @name_space )
        end
      end
    end

    def create_children patterns
      @patterns = []
      patterns.each do |p|
        if p["include"]
          @patterns << SyntaxProxy.new( p, self.syntax )
        else
          @patterns << SyntaxNode.new( p, self.syntax, @name_space )
        end
      end
    end

    def parse_captures name, pattern, match, processor
      captures = pattern.match_captures( name, match )
      captures.reject! { |group, range, name| ! range.first || range.first == range.last }
      starts = []
      ends = []
      captures.each do |group, range, name|
        starts << [range.first, group, name]
        ends   << [range.last, -group, name]
      end

#          STDERR.puts '-' * 100
#          starts.sort!.reverse!.each{|c| STDERR.puts c.join(', ')}
#          STDERR.puts 
#          ends.sort!.reverse!.each{|c| STDERR.puts c.join(', ')}
      starts.sort!.reverse!
      ends.sort!.reverse!

      while ! starts.empty? || ! ends.empty?
        if starts.empty?
          pos, key, name = ends.pop
          processor.close_tag name, pos
        elsif ends.empty?
          pos, key, name = starts.pop
          processor.open_tag name, pos
        elsif ends.last[1].abs < starts.last[1]
          pos, key, name = ends.pop
          processor.close_tag name, pos
        else
          pos, key, name = starts.pop
          processor.open_tag name, pos
        end
      end
    end

    def match_captures name, match
      matches = []
      captures = instance_variable_get "@#{name}"
      if captures
        captures.each do |key, value|
          if key =~ /^\d*$/
            matches << [key.to_i, match.offset( key.to_i ), value["name"]] if key.to_i < match.size
          else
            matches << [match.to_index( key.to_sym ), match.offset( key.to_sym), value["name"]] if match.to_index( key.to_sym )
          end
        end
      end
      matches
    end

    def match_first string, position
      if self.match
        if match = self.match.match( string, position )
          return [self, match]
        end
      elsif self.begin
        if match = self.begin.match( string, position )
          return [self, match]
        end
      elsif self.end
      else
        return match_first_son( string, position )
      end
      nil
    end

    def match_end string, match, position
      regstring = self.end.clone
      regstring.gsub!( /\\([1-9])/ ) { |s| match[$1.to_i] }

      # in spox-textpow this is \\g in 1.9 !?
      regstring.gsub!( /\\k<(.*?)>/ ) { |s| match[$1.to_sym] }
      if Textpow::RUBY_19
        Regexp.new( regstring ).match( string, position )
      else
        Oniguruma::ORegexp.new( regstring ).match( string, position )
      end
    end

    def match_first_son(string, position)
      return if not patterns

      match = nil
      patterns.each do |p|
        tmatch = p.match_first string, position
        if tmatch
          if not match or match_offset(match[1]).first > match_offset(tmatch[1]).first
            match = tmatch
          end
          #break if tmatch[1].offset.first == position
        end
      end
      match
    end

    def parse_line(stack, line, processor)
      processor.new_line line
      top, match = stack.last
      position = 0
      #@ln ||= 0
      #@ln += 1
      #STDERR.puts @ln
      loop do
        if top.patterns
          pattern, pattern_match = top.match_first_son(line, position)
        end

        if top.end
          end_match = top.match_end( line, match, position )
        end

        if end_match and (not pattern_match or match_offset(pattern_match).first >= match_offset(end_match).first)
          pattern_match = end_match
          start_pos = match_offset(pattern_match).first
          end_pos = match_offset(pattern_match).last

          processor.close_tag top.contentName, start_pos if top.contentName
          parse_captures "captures", top, pattern_match, processor
          parse_captures "endCaptures", top, pattern_match, processor
          processor.close_tag top.name, end_pos if top.name
          stack.pop
          top, match = stack.last
        else
          break unless pattern

          start_pos = match_offset(pattern_match).first
          end_pos = match_offset(pattern_match).last

          if pattern.begin
            processor.open_tag pattern.name, start_pos if pattern.name
            parse_captures "captures", pattern, pattern_match, processor
            parse_captures "beginCaptures", pattern, pattern_match, processor
            processor.open_tag pattern.contentName, end_pos if pattern.contentName
            top = pattern
            match = pattern_match
            stack << [top, match]
          elsif pattern.match
            processor.open_tag pattern.name, start_pos if pattern.name
            parse_captures "captures", pattern, pattern_match, processor
            processor.close_tag pattern.name, end_pos if pattern.name
          end
        end

        position = end_pos
      end
    end

    def match_offset(match)
      if Textpow::RUBY_19
        match.offset(0)
      else
        match.offset
      end
    end
  end
end
