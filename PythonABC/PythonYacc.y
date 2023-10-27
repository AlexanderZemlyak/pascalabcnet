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

%start root

%token INDENT UNINDENT STUFF REST

%type <stVal> stuff
%type <blVal> root

%%

root	: root stuff
		| stuff
		;

stuff	: STUFF 
		{ Console.WriteLine("STUFF"); }
     	| STUFF REST 
		{ Console.WriteLine("STUFF REST"); }
     	| INDENT 
		{ Console.WriteLine("INDENT"); }
     	| UNINDENT 
		{ Console.WriteLine("UNINDENT"); }
    ;

%%

