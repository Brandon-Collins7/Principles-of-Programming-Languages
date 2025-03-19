#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        t = term()
        if (@lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP)
            op = etail()
            op.addChild(t)
            return op
        end
        return t
    end

    def term()
        f = factor()
        if (@lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP)
            op = ttail()
            op.addChild(f)
            return op
        end
        return f
    end

    def factor()
        f = AST.new(Token.new("factor","factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            f = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            f = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            f = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return f
    end

    def ttail()
        tt = AST.new(Token.new("ttail","ttail"))
        if (@lookahead.type == Token::MULTOP)
            tt = AST.new(@lookahead)
            match(Token::MULTOP)
            f = factor()
            tt.addChild(f)
            ttNext = ttail()
            if (ttNext != nil)
                tt.addChild(ttNext)
            end
        elsif (@lookahead.type == Token::DIVOP)
            tt = AST.new(@lookahead)
            match(Token::DIVOP)
            f = factor()
            tt.addChild(f)
            ttNext = ttail()
            if (ttNext != nil)
                tt.addChild(ttNext)
            end
		else
			return nil
        end
        return tt
    end

    def etail()
        et = AST.new(Token.new("etail","etail"))
        if (@lookahead.type == Token::ADDOP)
            et = AST.new(@lookahead)
            match(Token::ADDOP)
            t = term()
            et.addChild(t)

            etNext = etail()
            if (etNext != nil)
                et.addChild(etNext)
            end
        elsif (@lookahead.type == Token::SUBOP)
            et = AST.new(@lookahead)
            match(Token::SUBOP)
            t = term()
            et.addChild(t)
            
            etNext = etail()
            if (etNext != nil)
                et.addChild(etNext)
            end
		else
			return nil
        end
        return et
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end
