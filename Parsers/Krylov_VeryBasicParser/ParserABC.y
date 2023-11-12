%{
   	public syntax_tree_node root;
	public List<Error> errors;
    public string current_file_name;
    public int max_errors = 10;
	public VeryBasicParserTools parsertools;
    public List<compiler_directive> CompilerDirectives;
   	public VeryBasicGPPGParser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
%}

%using PascalABCCompiler.SyntaxTree;
%using PascalABCCompiler.ParserTools;
%using PascalABCCompiler.Errors;
%using System.Linq;
%using SyntaxVisitors;
%using VeryBasicParser;

%output = VeryBasicParserYacc.cs
%partial
%parsertype VeryBasicGPPGParser

%namespace VeryBasicParserYacc

%union {
	public expression ex;
	public ident id;
    public Object ob;
    public op_type_node op;
    public syntax_tree_node stn;
    public token_info ti;
    public type_definition td;
}

%token <ti> FOR, IN, WHILE, IF, ELSE
%token <ex> INTNUM, REALNUM
%token <ti> LPAR, RPAR, LBRACE, RBRACE, LBRACKET, RBRACKET, DOT, COMMA, SEMICOLON
%token <op> ASSIGN
%token <op> PLUS, MINUS, MULTIPLY, DIVIDE
%token <id> ID
%token <op> LOWER, GREATER, LOWEREQUAL, GREATEREQUAL, EQUAL, NOTEQUAL

%left LOWER, GREATER, LOWEREQUAL, GREATEREQUAL, EQUAL, NOTEQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE

%type <id> ident
%type <ex> expr, var_reference, variable, proc_func_call
%type <stn> exprlist
%type <stn> assign ifstatement stmt proccall
%type <stn> stlist block
%type <stn> progr

%start progr

%%
progr   : stlist {
		var stl = $1 as statement_list;
			stl.left_logical_bracket = new token_info("");
			stl.right_logical_bracket = new token_info("");
			var un = new unit_or_namespace(new ident_list("SF"),null);
			uses_list ul = null;
			if (ul == null)
				ul = new uses_list(un,null);
			else ul.Insert(0,un);
			root = $$ = NewProgramModule(null, null, ul, new block(null, stl, @$), new token_info(""), @$);
	}
		;


stlist	: stmt { $$ = new statement_list($1 as statement, @1); }
		| stlist SEMICOLON stmt { $$ = ($1 as statement_list).Add($3 as statement, @$); }
		;

stmt	: assign { $$ = $1; }
		| block	{ $$ = $1; }
		| ifstatement { $$ = $1; }
		| proccall { $$ = $1; }
		;

ident 	: ID { $$ = $1; }
		;

assign 	: ident ASSIGN expr         {
			var vds = new var_def_statement(new ident_list($1, @1), null, $3, definition_attribute.None, false, @$);
			$$ = new var_statement(vds, @$);
		}
		;

expr 	: expr PLUS expr { $$ = new bin_expr($1, $3, $2.type, @$); }
		| expr MULTIPLY expr { $$ = new bin_expr($1, $3, $2.type, @$); }
		| expr MINUS expr { $$ = new bin_expr($1, $3, $2.type, @$); }
  		| expr LOWER expr { $$ = new bin_expr($1, $3, $2.type, @$); }
		| expr GREATER expr { $$ = new bin_expr($1, $3, $2.type, @$); }
		| ident { $$ = $1; }
		| INTNUM { $$ = $1; }
		| REALNUM { $$ = $1; }
		| LPAR expr RPAR { $$ = $2; }
		;

exprlist	: expr { $$ = new expression_list($1, @$); }
			| exprlist COMMA expr { $$ = ($1 as expression_list).Add($3, @$);  }
			;

ifstatement	: IF expr stmt { $$ = new if_node($2, $3 as statement, null, @$); }
			| IF expr block ELSE stmt { $$ = new if_node($2, $3 as statement, $5 as statement, @$); }
			;

proccall	:  var_reference
        	{
				$$ = new procedure_call($1 as addressed_value, $1 is ident, @$);
			}
			;

var_reference	: variable { $$ = $1; }
				;

variable	: ident { $$ = $1; }
			| proc_func_call { $$ = $1; }
			;

proc_func_call	: ident LPAR exprlist RPAR { $$ = new method_call($1 as addressed_value,$3 as expression_list, @$); }
				;

block	: LBRACE stlist RBRACE { $$ = $2; }
		;

%%

        public program_module NewProgramModule(program_name progName, Object optHeadCompDirs, uses_list mainUsesClose, syntax_tree_node progBlock, Object optPoint, LexLocation loc)
        {
            var progModule = new program_module(progName, mainUsesClose, progBlock as block, null, loc);
            progModule.Language = LanguageId.PascalABCNET;
            if (optPoint == null && progBlock != null)
            {
                var fp = progBlock.source_context.end_position;
                var err_stn = progBlock;
			    if ((progBlock is block) && (progBlock as block).program_code != null && (progBlock as block).program_code.subnodes != null && (progBlock as block).program_code.subnodes.Count > 0)
                    err_stn = (progBlock as block).program_code.subnodes[(progBlock as block).program_code.subnodes.Count - 1];
                parsertools.errors.Add(new PABCNETUnexpectedToken(parsertools.CurrentFileName, StringResources.Get("TKPOINT"), new SourceContext(fp.line_num, fp.column_num + 1, fp.line_num, fp.column_num + 1, 0, 0), err_stn));
            }
            return progModule;
        }
