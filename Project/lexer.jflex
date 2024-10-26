package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
Number     = [0-9]+

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"          { return symbolFactory.newSymbol("DIVIDE", DIVIDE); }
  "**"         { return symbolFactory.newSymbol("POW", POW); }
  "%"          { return symbolFactory.newSymbol("MOD", MOD); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  "="          { return symbolFactory.newSymbol("EQUAL", EQUAL); }
  "<>"         { return symbolFactory.newSymbol("NOTEQUAL", NOTEQUAL); }
  "<"          { return symbolFactory.newSymbol("LESSER", LESSER); }
  ">"          { return symbolFactory.newSymbol("GREATER", GREATER); }
  "<="         { return symbolFactory.newSymbol("LESSERE", LESSERE); }
  ">="         { return symbolFactory.newSymbol("GREATERE", GREATERE); }
  "and"        { return symbolFactory.newSymbol("AND", AND); }
  "or"         { return symbolFactory.newSymbol("OR", OR); }
  "not"        { return symbolFactory.newSymbol("NOT", NOT); }
  ":="		   { return symbolFactory.newSymbol("ASSIGNMENT", ASSIGNMENT);}
  "program"			{ return symbolFactory.newSymbol("PROGRAM", PROGRAM); }
  "endprogram"		{ return symbolFactory.newSymbol("ENDPROGRAM", ENDPROGRAM); }
  "return"			{ return symbolFactory.newSymbol("RETURN", RETURN); }
  "function"		{ return symbolFactory.newSymbol("FUNCTION", FUNCTION); }
  "endfunction"		{ return symbolFactory.newSymbol("ENDFUNCTION", ENDFUNCTION); }
  "string"			{ return symbolFactory.newSymbol("STRING", STRING); }
  "integer"			{ return symbolFactory.newSymbol("INTEGER", INTEGER); }
  "real"			{ return symbolFactory.newSymbol("REAL", REAL); }
  "if"				{ return symbolFactory.newSymbol("IF", IF); }
  "then"			{ return symbolFactory.newSymbol("THEN", THEN); }
  "else"			{ return symbolFactory.newSymbol("ELSE", ELSE); }
  "endif"			{ return symbolFactory.newSymbol("ENDIF", ENDIF); }
  "while"			{ return symbolFactory.newSymbol("WHILE", WHILE); }
  "do"				{ return symbolFactory.newSymbol("DO", DO); }
  "enddo"			{ return symbolFactory.newSymbol("ENDDO", ENDDO); }
  "for"				{ return symbolFactory.newSymbol("FOR", FOR); }
  "to"				{ return symbolFactory.newSymbol("TO", TO); }
  "endfor"			{ return symbolFactory.newSymbol("ENDFOR", ENDFOR); }
  "//"				{ return symbolFactory.newSymbol("COMMENT", COMMENT); }
  ","				{ return symbolFactory.newSymbol("COMMA", COMMA); }
  \"	     	    { return symbolFactory.newSymbol("QUOTE", QUOTE); }
  "read"			{ return symbolFactory.newSymbol("READ", READ); }
  "move"			{ return symbolFactory.newSymbol("MOVE", MOVE); }
  "draw"				{ return symbolFactory.newSymbol("DRAW", DRAW); }
  "write"			{ return symbolFactory.newSymbol("WRITE", WRITE); }
  "set color"		{ return symbolFactory.newSymbol("SETCOLOR", SETCOLOR); }
  "set line"		{ return symbolFactory.newSymbol("SETLINE", SETLINE); }
  "set color"		{ return symbolFactory.newSymbol("SETCOLOR", SETCOLOR); }
  {ident}			{ return symbolFactory.newSymbol("ID", ID, yytext()); }
  {Number}     { return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext())); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
