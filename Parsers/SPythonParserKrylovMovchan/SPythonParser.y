%{
   	public syntax_tree_node root;
	public List<Error> errors;
    // public string current_file_name;
    public int max_errors = 10;
	public SPythonParserTools parsertools;
    public List<compiler_directive> CompilerDirectives;
   	public SPythonGPPGParser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
	public ParserLambdaHelper lambdaHelper = new ParserLambdaHelper();

	private SymbolTable symbolTable = new SymbolTable();
	private SymbolTable globalVariables = new SymbolTable();
	private declarations decl_forward = new declarations();
	private declarations decl = new declarations();
	private bool isInsideFunction = false;
	private bool isVariableToBeAssigned = false;

	public bool is_unit_to_be_parsed = false;
%}

%using PascalABCCompiler.SyntaxTree;
%using PascalABCCompiler.ParserTools;
%using PascalABCCompiler.Errors;
%using System.Linq;
%using System.Collections.Generic;
%using System.IO;
%using SPythonParser;

%output = SPythonParserYacc.cs
%partial
%parsertype SPythonGPPGParser

%namespace SPythonParserYacc

%union {
	public expression ex;
	public ident id;
    public Object ob;
    public op_type_node op;
    public syntax_tree_node stn;
    public token_info ti;
    public type_definition td;
}

%token <ti> FOR IN WHILE IF ELSE ELIF DEF RETURN BREAK CONTINUE IMPORT FROM GLOBAL
%token <ex> INTNUM REALNUM TRUE FALSE
%token <ti> LPAR RPAR LBRACE RBRACE LBRACKET RBRACKET DOT COMMA COLON SEMICOLON INDENT UNINDENT ARROW
%token <stn> STRINGNUM
%token <op> ASSIGN
%token <op> PLUS MINUS STAR DIVIDE SLASHSLASH PERCENTAGE
%token <id> ID
%token <op> LESS GREATER LESSEQUAL GREATEREQUAL EQUAL NOTEQUAL
%token <op> AND OR NOT

%left OR
%left AND
%left LESS GREATER LESSEQUAL GREATEREQUAL EQUAL NOTEQUAL
%left PLUS MINUS
%left STAR DIVIDE SLASHSLASH PERCENTAGE
%left NOT

%type <id> ident dotted_ident range_ident func_name_ident
%type <ex> expr proc_func_call const_value complex_variable variable complex_variable_or_ident optional_condition
%type <stn> expr_list optional_expr_list proc_func_decl return_stmt break_stmt continue_stmt global_stmt
%type <stn> assign_stmt if_stmt stmt proc_func_call_stmt while_stmt for_stmt optional_else optional_elif
%type <stn> decl_or_stmt decl_and_stmt_list
%type <stn> stmt_list block
%type <stn> program decl param_name form_param_sect form_param_list optional_form_param_list dotted_ident_list
%type <td> proc_func_header form_param_type simple_type_identifier
%type <stn> import_clause import_clause_one

%start program

/*
ident	= identifier
expr	= expression
stmt	= statement
proc	= procedure
func	= function
const	= constant
decl	= declaration
param	= parameter
assign	= assignment
form	= formal
sect	= section
*/

%%
program
	: import_clause decl_and_stmt_list
		{
			// main program
			if (!is_unit_to_be_parsed) {
				var ul = $1 as uses_list;
				var stl = $2 as statement_list;
				decl.AddFirst(decl_forward.defs);
				root = $$ = NewProgramModule(null, null, ul, new block(decl, stl, @2), new token_info(""), @$);
				$$.source_context = @$;
			}
			// unit
			else {
				decl.AddFirst(decl_forward.defs);
				var interface_part = new interface_node(decl as declarations, $1 as uses_list, null, null);
				var initialization_part = new initfinal_part(null, $2 as statement_list, null, null, null, @$);

				root = $$ = new unit_module(
					new unit_name(new ident(Path.GetFileNameWithoutExtension(parsertools.CurrentFileName)),
					UnitHeaderKeyword.Unit, @$), interface_part, null,
					initialization_part.initialization_sect,
					initialization_part.finalization_sect, null, @$);
			}

		}
	;

import_clause
	:
		{
			$$ = null;
		}
	| import_clause import_clause_one
		{
   			if (parsertools.build_tree_for_formatter)
   			{
	        	if ($1 == null)
                {
	        		$$ = new uses_closure($2 as uses_list,@$);
                }
	        	else {
                    ($1 as uses_closure).AddUsesList($2 as uses_list,@$);
                    $$ = $1;
                }
   			}
   			else
   			{
	        	if ($1 == null)
                {
                    $$ = $2;
                    $$.source_context = @$;
                }
	        	else
                {
                    ($1 as uses_list).AddUsesList($2 as uses_list,@$);
                    $$ = $1;
                    $$.source_context = @$;
                }
			}
		}
	;

import_clause_one
	: FROM ident IMPORT STAR SEMICOLON
		{
			$$ = new uses_list(new unit_or_namespace(new ident_list($2 as ident, @2), @2),@2);
			$$.source_context = @$;
		}
	;

decl_or_stmt
	: stmt
		{ $$ = $1; }
	| decl
		{ $$ = null; }
	;

decl
	: proc_func_decl
		{
			$$ = null;
			decl.Add($1 as procedure_definition, @$);
		}
	;

decl_and_stmt_list
	: decl_or_stmt
		{
			if ($1 is statement st)
				$$ = new statement_list($1 as statement, @1);
			else
				$$ =  new statement_list();
		}
	| decl_and_stmt_list SEMICOLON decl_or_stmt
		{
			if ($3 is statement st)
				$$ = ($1 as statement_list).Add(st, @$);
			else
				$$ = ($1 as statement_list);
		}
	;

stmt_list
	: stmt
		{
			$$ = new statement_list($1 as statement, @1);
		}
	| stmt_list SEMICOLON stmt
		{
			$$ = ($1 as statement_list).Add($3 as statement, @$);
		}
	;

stmt
	: assign_stmt
		{ $$ = $1; }
	| block
		{ $$ = $1; }
	| if_stmt
		{ $$ = $1; }
	| proc_func_call_stmt
		{ $$ = $1; }
	| while_stmt
		{ $$ = $1; }
	| for_stmt
		{ $$ = $1; }
	| return_stmt
		{ $$ = $1; }
	| break_stmt
		{ $$ = $1; }
	| continue_stmt
		{ $$ = $1; }
	| global_stmt
		{ $$ = $1; }
	;

global_stmt
	: GLOBAL dotted_ident_list
		{
			foreach (var id in ($2 as ident_list).idents) {
				// имя параметра совпадает с именем глобальной переменной
				if (symbolTable.Contains(id.name)) {
					parsertools.AddErrorFromResource("GLOBAL_VAR_{0}_SIM_PARAMETER", @$, id.name);
					$$ = null;
				}
				// всё отлично!
				else {
					symbolTable.Add(id.name);
					$$ = new empty_statement();
					$$.source_context = null;
				}
			}
		}
	;

ident
	: ID
		{
			if ($1.name == "result")
				$1.name = "%result";

			$$ = $1;
		}
	;

dotted_ident
	: ident
		{ $$ = $1; }
	| dotted_ident DOT ident
		{
			$$ = new ident($1.name + "." + $3.name);
		}
	;

dotted_ident_list
    : dotted_ident
        {
			$$ = new ident_list($1, @$);
		}
    | dotted_ident_list COMMA dotted_ident
        {
			$$ = ($1 as ident_list).Add($3, @$);
		}
    ;

assign_stmt
	: variable ASSIGN expr
		{
			if ($1 is ident id) {
				// объявление
				if (!symbolTable.Contains(id.name) && (isInsideFunction || !globalVariables.Contains(id.name))) {

					// объявление глобальной переменной
					if (symbolTable.OuterScope == null) {
						// var vds = new var_def_statement(new ident_list(id, @1), new same_type_node($3), null, definition_attribute.None, false, @$);
						var vds = new var_def_statement(new ident_list(id, @1), new named_type_reference(new ident("integer")), null, definition_attribute.None, false, @$);
						globalVariables.Add(id.name);
						decl.Add(new variable_definitions(vds, @$), @$);
						//decl.AddFirst(new variable_definitions(vds, @$));

						var ass = new assign(id as addressed_value, $3, $2.type, @$);
						ass.first_assignment_defines_type = true;
						$$ = ass;
					}
					// объявление локальной переменной
					else {
						var vds = new var_def_statement(new ident_list(id, @1), null, $3, definition_attribute.None, false, @$);
						symbolTable.Add(id.name);
						$$ = new var_statement(vds, @$);
					}
				}
				// присваивание
				else {
					$$ = new assign(id as addressed_value, $3, $2.type, @$);
				}
			}
			else {
				$$ = new assign($1 as addressed_value, $3, $2.type, @$);
			}
		}
	;

expr
	: expr PLUS 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr STAR 	expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr DIVIDE 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr MINUS 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
  	| expr LESS 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr GREATER 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr LESSEQUAL 	expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr GREATEREQUAL expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr EQUAL 		expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr NOTEQUAL 	expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr AND 			expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr OR 			expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr SLASHSLASH	expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| expr PERCENTAGE	expr
		{ $$ = new bin_expr($1, $3, $2.type, @$); }
	| MINUS	expr
		{ $$ = new un_expr($2, $1.type, @$); }
	| NOT	expr
		{ $$ = new un_expr($2, $1.type, @$); }
	| complex_variable
		{ $$ = $1; }
	| const_value
		{ $$ = $1; }
	| LPAR expr RPAR
		{ $$ = $2; }
	| ident
		{
			// Проверка на то что пытаемся считать не инициализированную переменную
			//if (!symbolTable.Contains($1.name) && !globalVariables.Contains($1.name))
					//parsertools.AddErrorFromResource("USING_VARIABLE_{0}_BEFORE_ASSIGNMENT", @$, $1.name);

			$$ = $1;
		}
	;

const_value
	: INTNUM
		{ $$ = $1; }
	| REALNUM
		{ $$ = $1; }
	| TRUE
		{ $$ = new ident("true"); }
	| FALSE
		{ $$ = new ident("false"); }
	| STRINGNUM
		{ $$ = $1 as literal; }
	;

optional_expr_list
	: expr_list
		{ $$ = $1; }
	|
		{ $$ = null; }
	;

expr_list
	: expr
		{
			$$ = new expression_list($1, @$);
		}
	| expr_list COMMA expr
		{
			$$ = ($1 as expression_list).Add($3, @$);
		}
	;

if_stmt
	: IF expr COLON block optional_elif
		{
			$$ = new if_node($2, $4 as statement, $5 as statement, @$);
		}
	;

optional_elif
	: ELIF expr COLON block optional_elif
		{
			$$ = new if_node($2, $4 as statement, $5 as statement, @$);
		}
	| optional_else
		{ $$ = $1; }
	;

optional_else
	: ELSE COLON block
		{ $$ = $3; }
	|
		{ $$ = null; }
	;

while_stmt
	: WHILE expr COLON block
		{
			$$ = new while_node($2, $4 as statement, WhileCycleType.While, @$);
		}
	;

for_stmt
	: FOR range_ident IN expr COLON block
		{
			$$ = new foreach_stmt($2, new no_type_foreach(), $4, (statement)$6, null, @$);
		}
	;

range_ident
	: ident
		{
			symbolTable.Add($1.name);
			$$ = $1;
		}
	;

func_name_ident
	: ident
		{
			globalVariables.Add($1.name);
			$$ = $1;
		}
	;

// return `expr` ~ result := `expr`; exit;
return_stmt
	: RETURN expr
		{
			statement res_assign = new assign(new ident("result"), $2, Operators.Assignment, @$);
			statement exit_call = new procedure_call(new ident("exit"), true, @$);
			$$ = new statement_list(res_assign, @$);
			($$  as statement_list).Add(exit_call, @$);
		}
	| RETURN
		{
			$$ = new procedure_call(new ident("exit"), true, @$);
		}
	;

break_stmt
	: BREAK
		{
			$$ = new procedure_call(new ident("break"), true, @$);
		}
	;

continue_stmt
	: CONTINUE
		{
			$$ = new procedure_call(new ident("continue"), true, @$);
		}
	;

proc_func_call_stmt
	:  proc_func_call
        {
			$$ = new procedure_call($1 as addressed_value, $1 is ident, @$);
		}
	;

variable
	: ident
		{ $$ = $1; }
	| complex_variable
		{ $$ = $1; }
	;

complex_variable
	: proc_func_call
		{ $$ = $1; }
	| complex_variable_or_ident DOT ident
		{ $$ = new dot_node($1 as addressed_value, $3 as addressed_value, @$); }
	| const_value DOT ident
		{ $$ = new dot_node($1 as addressed_value, $3 as addressed_value, @$); }
	// list constant
	| LBRACKET expr_list RBRACKET
		{

			var acn = new array_const_new($2 as expression_list, @$); 
			var dn = new dot_node(acn as addressed_value, (new ident("ToList")) as addressed_value, @$);
			$$ = new method_call(dn as addressed_value, null, @$);
		}
	// index property
	| complex_variable_or_ident LBRACKET expr RBRACKET
		{
			var el = new expression_list($3 as expression);
			$$ = new indexer($1 as addressed_value, el, @$);
		}
	// list generator
	| LBRACKET expr FOR ident IN expr optional_condition RBRACKET
		{
			dot_node dn;
			ident_list idList;
			formal_parameters formalPars;
			statement_list sl;
			function_lambda_definition lambda;
			method_call mc;

			// [ expr1 for ident in expr2 if expr3 ] -> expr2.Where(ident -> expr3).Select(ident -> expr1).ToList()
			if ($7 != null) {
				string ident_name = $4.name;
				idList = new ident_list(new ident(ident_name), @4); 
				formalPars = new formal_parameters(new typed_parameters(idList, new lambda_inferred_type(new lambda_any_type_node_syntax(), @4), parametr_kind.none, null, @4), @4);

				dn = new dot_node($6 as addressed_value, (new ident("Where")) as addressed_value, @$);
			
				sl = new statement_list(new assign("result",$7,@8),@8);
				sl.expr_lambda_body = true;
				lambda = new function_lambda_definition(
				lambdaHelper.CreateLambdaName(), formalPars, 
				new lambda_inferred_type(new lambda_any_type_node_syntax(), @4), sl, @$);

				mc = new method_call(dn as addressed_value, new expression_list(lambda as expression), @$);
				dn = new dot_node(mc as addressed_value, (new ident("Select")) as addressed_value, @$);
			}
			// [ expr1 for ident in expr2 ] -> expr2.Select(ident -> expr1).ToList()
			else
				dn = new dot_node($6 as addressed_value, (new ident("Select")) as addressed_value, @$);

			
			idList = new ident_list($4, @4); 
			formalPars = new formal_parameters(new typed_parameters(idList, new lambda_inferred_type(new lambda_any_type_node_syntax(), @4), parametr_kind.none, null, @4), @4);
			
			sl = new statement_list(new assign("result",$2,@2),@2);
			sl.expr_lambda_body = true;

			lambda = new function_lambda_definition(
				lambdaHelper.CreateLambdaName(), formalPars, 
				new lambda_inferred_type(new lambda_any_type_node_syntax(), @4), sl, @$);


			mc = new method_call(dn as addressed_value, new expression_list(lambda as expression), @$);
			dn = new dot_node(mc as addressed_value, (new ident("ToList")) as addressed_value, @$);
			$$ = new method_call(dn as addressed_value, null, @$);
		}
	;

optional_condition
	: 
		{ $$ = null; }
	| IF expr
		{ $$ = $2; }
	;

complex_variable_or_ident
	: ident
		{ $$ = $1; }
	| complex_variable
		{ $$ = $1; }
	;

block
	: NestedSymbolTableBegin INDENT stmt_list SEMICOLON UNINDENT NestedSymbolTableEnd
		{
			$$ = $3 as statement_list;
			($$ as statement_list).left_logical_bracket = $2;
			($$ as statement_list).right_logical_bracket = $5;
			$$.source_context = @$;
		}
	;

NestedSymbolTableBegin
	:
		{
			symbolTable = new SymbolTable(symbolTable);
		}
	;

NestedSymbolTableEnd
	:
		{
			symbolTable = symbolTable.OuterScope;
		}
	;

proc_func_decl
	: NestedSymbolTableBegin proc_func_header InsideFunction block OutsideFunction NestedSymbolTableEnd
		{
			//var pd1 = new procedure_definition($1 as procedure_header, new block(null, $2 as statement_list, @2), @$);
			//pd1.AssignAttrList(null);
			//$$ = pd1;
			$$ = new procedure_definition($2 as procedure_header, new block(null, $4 as statement_list, @4), @$);

			var pd = new procedure_definition($2 as procedure_header, null, @2);
            pd.proc_header.proc_attributes.Add(new procedure_attribute(proc_attribute.attr_forward));
			decl_forward.Add(pd, @2);
		}
	;

InsideFunction
	:
		{
			isInsideFunction = true;
		}
	;

OutsideFunction
	:
		{
			isInsideFunction = false;
		}
	;

proc_func_header
	: DEF func_name_ident LPAR optional_form_param_list RPAR COLON
		{
			$$ = new procedure_header($4 as formal_parameters, new procedure_attributes_list(new List<procedure_attribute>(), @$), new method_name(null,null, $2, null, @$), null, @$);
		}
	| DEF func_name_ident LPAR optional_form_param_list RPAR ARROW form_param_type COLON
		{
			$$ = new function_header($4 as formal_parameters, new procedure_attributes_list(new List<procedure_attribute>(), @$), new method_name(null,null, $2, null, @$), null, $7 as type_definition, @$);
		}
	;

proc_func_call
	: variable LPAR optional_expr_list RPAR
		{
			$$ = new method_call($1 as addressed_value, $3 as expression_list, @$);
		}
	;

simple_type_identifier
	: ident
		{
			switch ($1.name) {
				case "bool":
					$$ = new named_type_reference("boolean", @$);
					break;
				case "int":
					$$ = new named_type_reference("integer", @$);
					break;
				case "float":
					$$ = new named_type_reference("real", @$);
					break;
				case "str":
					$$ = new named_type_reference("string", @$);
					break;

				case "integer":
				case "real":
				case "string":
				case "boolean":
					$$ = new named_type_reference("error", @$);
					break;

				default:
					$$ = new named_type_reference($1, @$);
					break;
			}
		}
	;

form_param_type
	: simple_type_identifier
		{
			$$ = $1 as named_type_reference;
		}
	;

param_name
	: ident
		{
			symbolTable.Add($1.name);
			$$ = new ident_list($1, @$);
		}
    ;

form_param_sect
	: param_name COLON form_param_type
		{
			$$ = new typed_parameters($1 as ident_list, $3, parametr_kind.none, null, @$);
		}
	;

form_param_list
    : form_param_sect
        {
			$$ = new formal_parameters($1 as typed_parameters, @$);
        }
    | form_param_list COMMA form_param_sect
        {
			$$ = ($1 as formal_parameters).Add($3 as typed_parameters, @$);
        }
    ;

optional_form_param_list
    : form_param_list
        {
			$$ = $1;
			if ($$ != null)
				$$.source_context = @$;
		}
	|
        {
			$$ = null;
		}
    ;

%%

        public program_module NewProgramModule(program_name progName, Object optHeadCompDirs, uses_list mainUsesClose, syntax_tree_node progBlock, Object optPoint, LexLocation loc)
        {
            var progModule = new program_module(progName, mainUsesClose, progBlock as block, null, loc);
            progModule.Language = LanguageId.SPython;
            if (optPoint == null && progBlock != null)
            {
                var fp = progBlock.source_context.end_position;
                var err_stn = progBlock;
			    if ((progBlock is block) && (progBlock as block).program_code != null && (progBlock as block).program_code.subnodes != null && (progBlock as block).program_code.subnodes.Count > 0)
                    err_stn = (progBlock as block).program_code.subnodes[(progBlock as block).program_code.subnodes.Count - 1];
                parsertools.errors.Add(new SPythonUnexpectedToken(parsertools.CurrentFileName, StringResources.Get("TKPOINT"), new SourceContext(fp.line_num, fp.column_num + 1, fp.line_num, fp.column_num + 1, 0, 0), err_stn));
            }
            return progModule;
        }
