%using PythonParser;
%using QUT.Gppg;
%using System.Linq;

%namespace PythonScanner

Alpha 	[a-zA-Z_]
Digit   [0-9] 
AlphaDigit {Alpha}|{Digit}
ID {Alpha}{AlphaDigit}* 

%{
/* globals to track current indentation */
int current_line_indent = 0;   /* indentation of the current line */
int indent_level = 0;          /* indentation level passed to the parser */
%}

%x indent 
/* start state for parsing the indentation */
%s normal 
/* normal start state for everything else */

%%

<indent>" "      { 
                    Console.WriteLine("<indent>\" \""); 
                    current_line_indent++; 
                  }
<indent>"\t"     { 
                    Console.WriteLine("<indent>\"\t\""); 
                    current_line_indent = (current_line_indent + 8) & (-8); 
                    }
<indent>"\n"     { 
                    Console.WriteLine("<indent>\"\n\"");  
                    current_line_indent = 0; /*ignoring blank line */
                  }
<indent>.        {
                    Console.WriteLine("<indent>.");  
                   //unput(*yytext);  problems finding an analogue (returns the read symbol to the stream)
                   Console.WriteLine(yytext);
                   if (current_line_indent > indent_level) {
                       indent_level++;
                       return (int)Tokens.INDENT;
                   } else if (current_line_indent < indent_level) {
                       indent_level--;
                       return (int)Tokens.UNINDENT;
                   } else {
                       BEGIN(normal);
                   }
                 }

<normal>"\n"     {  Console.WriteLine("<normal>\"\n\""); current_line_indent = 0; BEGIN(indent);  }

<normal>";" {  Console.WriteLine("<normal>\";\""); return (int)Tokens.SEMICOLON; }

<normal>{ID} { Console.WriteLine("<normal>{ID}"); return (int)Tokens.STUFF; }

[^ \r\n] {
	LexError();
}

%{
  yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol);
%}

%%

public void LexError()
{
  string errorMsg = string.Format("({0},{1}): unexpected token: {2}", yyline, yycol, yytext);
  throw new LexException(errorMsg); 
}

/* public override void yyerror(string format, params object[] args)
{
  var ww = args.Skip(1).Cast<string>().ToArray();
  string errorMsg = string.Format("({0},{1}): found {2}, but expected {3}", yyline, yycol, args[0], string.Join(" or ", ww));
  throw new SyntaxException(errorMsg); 
}



class ScannerHelper 
{
  private static Dictionary<string,int> keywords;

  static ScannerHelper() 
  {
    keywords = new Dictionary<string,int>();
    //keywords.Add("begin",(int)Tokens.BEGIN);
    //keywords.Add("end",(int)Tokens.END);
    //keywords.Add("cycle",(int)Tokens.CYCLE);
    //keywords.Add("write",(int)Tokens.WRITE);
    //keywords.Add("var",(int)Tokens.VAR);
  }
  public static int GetIDToken(string s)
  {
	if (keywords.ContainsKey(s.ToLower()))
	  return keywords[s];
	else
      return (int)Tokens.ID;
  }
  
} */
