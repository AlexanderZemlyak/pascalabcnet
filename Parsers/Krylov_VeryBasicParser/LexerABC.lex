%using PascalABCCompiler.VeryBasicParser;
%using QUT.Gppg;
%using PascalABCCompiler.SyntaxTree;
%using PascalABCCompiler.ParserTools;
%using VeryBasicParserYacc;
%using VeryBasicParser;

%namespace PascalABCCompiler.VeryBasicParser

Alpha 	[a-zA-Z_]
Digit   [0-9]
AlphaDigit {Alpha}|{Digit}
INTNUM  {Digit}+
REALNUM {INTNUM}\.{INTNUM}
ID {Alpha}{AlphaDigit}*
INDENT "@Indent"
UNINDENT "@Unindent"

%{
  public VeryBasicParserTools parsertools;
  public List<string> Defines = new List<string>();
  LexLocation currentLexLocation;
%}

%%

{INTNUM} {
  currentLexLocation = CurrentLexLocation;
  yylval.ex = parsertools.create_int_const(yytext,currentLexLocation);
  return (int)Tokens.INTNUM;
}

{REALNUM} {
  currentLexLocation = CurrentLexLocation;
  yylval.ex = parsertools.create_double_const(yytext,currentLexLocation);
  return (int)Tokens.REALNUM;
}

{INDENT} {
  return (int)Tokens.INDENT;
}

{UNINDENT} {
  return (int)Tokens.UNINDENT;
}

{ID}  {
  string cur_yytext = yytext;
  int res = Keywords.KeywordOrIDToken(cur_yytext);
  currentLexLocation = CurrentLexLocation;
  if (res == (int)Tokens.ID)
  {
    yylval.id = parsertools.create_ident(cur_yytext,currentLexLocation);
  }
  return res;
}

//"+"  { yylval.sVal = yytext; return (int)Tokens.PLUS; }
//"-"  { yylval.sVal = yytext; return (int)Tokens.MINUS; }
//"*"  { yylval.sVal = yytext; return (int)Tokens.MULTIPLY; }
//"/"  { yylval.sVal = yytext; return (int)Tokens.DIVIDE; }
//"<"  { yylval.sVal = yytext; return (int)Tokens.LOWER; }
">"  { yylval.op = new op_type_node(Operators.Greater); return (int)Tokens.GREATER; }

"{"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.LBRACE; }
"}"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.RBRACE; }
"["  { currentLexLocation = CurrentLexLocation; return (int)Tokens.LBRACKET; }
"]"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.RBRACKET; }

"."  { currentLexLocation = CurrentLexLocation; return (int)Tokens.DOT; }
","  { currentLexLocation = CurrentLexLocation; return (int)Tokens.COMMA; }
":"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.COLON; }
";"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.SEMICOLON; }
"("  { currentLexLocation = CurrentLexLocation; return (int)Tokens.LPAR; }
")"  { currentLexLocation = CurrentLexLocation; return (int)Tokens.RPAR; }
"="  { yylval.op = new op_type_node(Operators.Assignment); currentLexLocation = CurrentLexLocation; return (int)Tokens.ASSIGN; }


[^ \r\n] {
  parsertools.AddError("Unexpected token!", CurrentLexLocation);
	return (int)Tokens.EOF;
}

%{
  yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol); // ������� ������� (������������� ��� ���������������), ������������ @1 @2 � �.�.
%}

%%

public LexLocation CurrentLexLocation
{
  get {
    return new LexLocation(tokLin, tokCol, tokELin, tokECol, parsertools.CurrentFileName);
	}
}

public override void yyerror(string format, params object[] args)
{
	string errorMsg = parsertools.CreateErrorString(yytext, yylloc, args);
	parsertools.AddError(errorMsg,CurrentLexLocation);
}
