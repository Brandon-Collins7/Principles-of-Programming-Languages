#
#  Parser Class
#
load "TinyToken.rb"
load "TinyLexer.rb"
class Parser < Lexer

	

	def initialize(filename)
    	super(filename)
		@errors = 0 #intilaize errors
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	#including because test output uses Token abbreviation for "Found"
	#while using the string name for "Expected"
	def found(token)
		puts "Found #{token} Token: #{@lookahead.text}"
    end

	#edit this method if multiple possible expected tokens
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
			@errors += 1
      	end
      	consume()
   	end
   	
	def program()
	
		while( @lookahead.type != Token::EOF)
        	puts "Entering STMTSEQ Rule"
			stmtseq()
      	end
		
		puts "There were #{@errors} parse errors found."
   	end

	def stmtseq()
		#ENDOP check is key here
		while( @lookahead.type != Token::EOF && @lookahead.type != Token::ENDOP)
        	puts "Entering STMT Rule"
			statement()  
      	end
		puts "Exiting STMTSEQ Rule"
	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			found("PRINT")
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		elsif (@lookahead.type == Token::IFOP)
			puts "Entering IFSTMT Rule"
			found("IFOP")
			match(Token::IFOP)
			ifstmt()
		elsif (@lookahead.type == Token::WHILEOP)
			puts "Entering LOOPSTMT Rule"
			found("WHILEOP")
			match(Token::WHILEOP)
			loopstmt()
		else #test output makes assumption to try ASSGN otherwise
			puts "Entering ASSGN Rule"
			assign()
		end
		
		puts "Exiting STMT Rule"
	end

	def ifstmt()
		#already found IFOP
		puts "Entering COMPARISON Rule"
		comparison()
		if (@lookahead.type == Token::THENOP)
			found("THENOP")
		end
		match(Token::THENOP)
		puts "Entering STMTSEQ Rule"
		stmtseq() ##
		if (@lookahead.type == Token::ENDOP)
			found("ENDOP")
		end
		match(Token::ENDOP)
		puts "Exiting IFSTMT Rule"
	end

	def loopstmt()
		#already found WHILEOP
		puts "Entering COMPARISON Rule"
		comparison()
		if (@lookahead.type == Token::THENOP)
			found("THENOP")
		end
		match(Token::THENOP)
		puts "Entering STMTSEQ Rule"
		stmtseq()
		if (@lookahead.type == Token::ENDOP)
			found("ENDOP")
		end
		match(Token::ENDOP)
		puts "Exiting LOOPSTMT Rule"
	end

	def comparison()
		puts "Entering FACTOR Rule"
		factor()

		if (@lookahead.type == Token::LT)
			found("LT")
			match(Token::LT)
		elsif (@lookahead.type == Token::GT)
			found("GT")
			match(Token::GT)
		elsif (@lookahead.type == Token::ANDOP)
			found("ANDOP")
			match(Token::ANDOP)
		else
			puts "Expected LT or GT or ANDOP found #{@lookahead.text}"
			@errors += 1
		end

		puts "Entering FACTOR Rule"
		factor()

		puts "Exiting COMPARISON Rule"
	end




	def assign()

		if (@lookahead.type == Token::ID)
			found("ID")
		end
		match(Token::ID)
		if (@lookahead.type == Token::ASSGN)
			found("ASSGN")
		end
		match(Token::ASSGN)
		puts "Entering EXP Rule"
		exp()
		puts "Exiting ASSGN Rule"
	end

	def exp()
		puts "Entering TERM Rule"
		term()
		puts "Entering ETAIL Rule"
		etail()
		puts "Exiting EXP Rule"
	end

	def etail()
		if (@lookahead.type == Token::ADDOP)
			found("ADDOP")
			match(Token::ADDOP)
			puts "Entering TERM Rule"
			term()
			puts "Entering ETAIL Rule"
			etail()
		elsif (@lookahead.type == Token::SUBOP)
			found("SUBOP")
			match(Token::SUBOP)
			puts "Entering TERM Rule"
			term()
			puts "Entering ETAIL Rule"
			etail()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end
		puts "Exiting ETAIL Rule"
	end
		
	def term()
		puts "Entering FACTOR Rule"
		factor()
		puts "Entering TTAIL Rule"
		ttail()
		puts "Exiting TERM Rule"
	end

	def ttail()
		if (@lookahead.type == Token::MULTOP)
			found("MULTOP")
			match(Token::MULTOP)
			puts "Entering FACTOR Rule"
			factor()
			puts "Entering TTAIL Rule"
			ttail()
		elsif (@lookahead.type == Token::DIVOP)
			found("DIVOP")
			match(Token::DIVOP)
			puts "Entering FACTOR Rule"
			factor()
			puts "Entering TTAIL Rule"
			ttail()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
		puts "Exiting TTAIL Rule"
	end
	
	def factor()
		if (@lookahead.type == Token::LPAREN)
			found("LPAREN")
			match(Token::LPAREN)
			puts "Entering EXP Rule"
			exp()
			found("RPAREN")
			match(Token::RPAREN)
		elsif (@lookahead.type == Token::ID)
			found("ID")
			match(Token::ID)
		elsif (@lookahead.type == Token::INT)
			found("INT")
			match(Token::INT)
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@errors += 1
		end
		puts "Exiting FACTOR Rule"
	end

end
