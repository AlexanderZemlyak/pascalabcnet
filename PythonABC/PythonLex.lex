%using PythonParser;
%using QUT.Gppg;
%using System.Linq;
%using System.Collections;

%namespace PythonScanner

Alpha 	[a-zA-Z_]
Digit   [0-9] 
AlphaDigit {Alpha}|{Digit}
ID {Alpha}{AlphaDigit}* 

%{
int g_current_line_indent = 0;
Stack<int> g_indent_levels = new Stack<int>();
int g_is_fake_outdent_symbol = 0;

const int TAB_WIDTH = 8;

int indent_caller = normal;

int yycolumn = 1;
void set_yycolumn(int val) {
    yycolumn = val;
    yylloc.StartColumn = yycolumn;
    yylloc.EndColumn = yycolumn + yyleng - 1;
}
%}

%x indent
%s normal

%%

<INITIAL>. { Console.WriteLine("<INITIAL>."); g_indent_levels.Push(0); set_yycolumn(yycolumn-1); indent_caller = normal; yyless(0); BEGIN(indent); }

<indent>" "     { Console.WriteLine("<indent>\" \""); g_current_line_indent++; }
<indent>"\t"      { Console.WriteLine("<indent>\"\\t\""); g_current_line_indent = (g_current_line_indent + TAB_WIDTH) & 56; } // temp
<indent>"\n"     { Console.WriteLine("<indent>\"\\n\""); g_current_line_indent = 0; /* ignoring blank line */ }
<indent><<EOF>> {
                    Console.WriteLine("<indent><<EOF>>");
                    // When encountering the end of file, we want to emit an
                    // outdent for all indents currently left.
                    if(g_indent_levels.Peek() != 0) {
                        g_indent_levels.Pop();

                        // See the same code below (<indent>.) for a rationale.
                        if(g_current_line_indent != g_indent_levels.Peek()) {
                            yyless(0); //unput('\n');
                            for(int i = 0 ; i < g_indent_levels.Peek() ; ++i) {
                                yyless(0); //unput(' ');
                            }
                        } else {
                            BEGIN(indent_caller);
                        }

                        return (int)Tokens.UNINDENT;
                    } else {
                        //yyterminate(); WTF
                    }
                }

<indent>.       {
                    if(g_is_fake_outdent_symbol == 0) {
                        yyless(0); //unput(*yytext);
                    }
                    set_yycolumn(yycolumn-1);
                    g_is_fake_outdent_symbol = 0;

                    // Indentation level has increased. It can only ever
                    // increase by one level at a time. Remember how many
                    // spaces this level has and emit an indentation token.
                    if(g_current_line_indent > g_indent_levels.Peek()) {
                        g_indent_levels.Push(g_current_line_indent);
                        BEGIN(indent_caller);
                        return (int)Tokens.INDENT;
                    } else if(g_current_line_indent < g_indent_levels.Peek()) {
                        // Outdenting is the most difficult, as we might need to
                        // outdent multiple times at once, but flex doesn't allow
                        // emitting multiple tokens at once! So we fake this by
                        // 'unput'ting fake lines which will give us the next
                        // outdent.
                        g_indent_levels.Pop();

                        if(g_current_line_indent != g_indent_levels.Peek()) {
                            // Unput the rest of the current line, including the newline.
                            // We want to keep it untouched.
                            for(int i = 0 ; i < g_current_line_indent ; ++i) {
                                yyless(0); //unput(' ');
                            }
                            yyless(0); //unput('\n');
                            // Now, insert a fake character indented just so
                            // that we get a correct outdent the next time.
                            yyless(0);  //unput('.');
                            // Though we need to remember that it's a fake one
                            // so we can ignore the symbol.
                            g_is_fake_outdent_symbol = 1;
                            for(int i = 0 ; i < g_indent_levels.Peek() ; ++i) {
                                yyless(0); //unput(' ');
                            }
                            yyless(0); //unput('\n');
                        } else {
                            BEGIN(indent_caller);
                        }

                        return (int)Tokens.UNINDENT;
                    } else {
                        // No change in indentation, not much to do here...
                        BEGIN(indent_caller);
                    }
                }

<normal>"\n"    { g_current_line_indent = 0; indent_caller = YY_START; BEGIN(INITIAL); }
<normal>"stuff" { return (int)Tokens.STUFF; }
<normal>" ".+ { return (int)Tokens.REST; }

<normal>[^ \r\n] {
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
