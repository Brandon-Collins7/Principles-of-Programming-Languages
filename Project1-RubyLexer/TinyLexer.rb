#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)

		#if file doesn't exist
		if (! File.file?(filename))
			puts "File does not exist"
			exit
		end
		
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		@f = File.open(filename,'r:utf-8')

		
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			return Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str = ""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
			
			#supposed to print for whitespace?
			return Token.new(Token::WS,str)
			
		elsif (letter?(@c))
			str = ""
			while letter?(@c)
				str += @c
				nextCh()
			end

			if str == "print"
				return Token.new(Token::PR,str)
			else
				return Token.new(Token::ID,str)
			end
		
		elsif (numeric?(@c))
			str = ""
			while numeric?(@c)
				str += @c
				nextCh()
			end
		
			return Token.new(Token::INT,str)
		
		elsif @c == "("
			nextCh()
			return Token.new(Token::LPAREN,"(")
		elsif @c == ")"
			nextCh()
			return Token.new(Token::RPAREN,")")
		
		elsif @c == "+"
			nextCh()
			return Token.new(Token::ADDOP,"+")
		elsif @c == "-"
			nextCh()
			return Token.new(Token::SUBOP,"-")
		elsif @c == "*"
			nextCh()
			return Token.new(Token::MULOP,"*")
		elsif @c == "/"
			nextCh()
			return Token.new(Token::DIVOP,"/")
		elsif @c == "="
			nextCh()
			return Token.new(Token::EQ,"=")
		elsif @c == ";"
			nextCh()
			return Token.new(Token::SEMI,";")
		elsif @c == "<"
			nextCh()
			return Token.new(Token::LEFTARR,"<")
		elsif @c == ">"
			nextCh()
			return Token.new(Token::RIGHTARR,">")
		elsif @c == "!"
			nextCh()
			return Token.new(Token::EXCL,"!")
		elsif @c == "&"
			nextCh()
			return Token.new(Token::AND,"&")

		end

		# elsif ...
		# more code needed here! complete the code here 
		# so that your scanner can correctly recognize,
		# print (to a text file), and display all tokens
		# in our grammar that we found in the source code file
		
		# FYI: You don't HAVE to just stick to if statements
		# any type of selection statement "could" work. We just need
		# to be able to programatically identify tokens that we 
		# encounter in our source code file.
		
		# don't want to give back nil token!
		# remember to include some case to handle
		# unknown or unrecognized tokens.
		# below is an example of how you "could"
		# create an "unknown" token directly from 
		# this scanner. You could also choose to define
		# this "type" of token in your token class
		
		nextCh()
		tok = Token.new(Token::UNKWN,@c)
		return tok
		end
	
end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end