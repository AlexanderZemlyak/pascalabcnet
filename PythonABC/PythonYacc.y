%{
    public Parser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
%}

%output = PythonYacc.cs

%union { 
			public double dVal; 
			public int iVal; 
			public string sVal; 
			public Node nVal;
			public ExprNode eVal;
			public StatementNode stVal;
			public BlockNode blVal;
       }

%using System.IO;
%using PythonProgramTree;

%namespace PythonParser

%start progr

%token INDENT UNINDENT STUFF SEMICOLON

%type <stVal> stuff
%type <blVal> block stlst

%%

progr	: stuff
		| block
		;

block	: INDENT stlst UNINDENT
		;

stlst	: stlst SEMICOLON stuff
		| stuff
		| block
		;

stuff	: STUFF
		;

%%

