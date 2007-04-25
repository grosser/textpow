module Textpow   
   class DebugProcessor
      def initialize
         @line_number = 0
         @printable_line = ""
      end
      
      def pprint line, string, position = 0
         line.replace line.ljust( position + string.size, " ")
         line[position,string.size] = string
         line
      end
      
      def open_tag name, position
         puts pprint( "", "{#{name}", position + @line_marks.size)
      end
      
      def close_tag name, position
         puts pprint( "", "}#{name}", position + @line_marks.size)
      end
      
      def new_line line
         @line_number += 1
         @line_marks = "[#{@line_number.to_s.rjust( 4, '0' )}] "
         puts "#{@line_marks}#{line}"
      end
      
      def start_parsing
      end
      
      def end_parsing
      end
   end
end
