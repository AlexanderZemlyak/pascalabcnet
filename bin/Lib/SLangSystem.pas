{$HiddenIdents}
unit SLangSystem;

interface

uses PABCSystem;

// Basic IO methods

function read_line(): string;

type 
    !Print = record
    public
        sep: string;
        &end:string;
        static function Get(sep:string := ' '; &end: string := #10): !Print;
        begin
          Result.sep := sep;
          Result.&end := &end;
        end;
        procedure Print(params args: array of object);
        begin
          for var i := 0 to args.length - 2 do
            Write(args[i], sep);
          if args.length <> 0 then 
            Write(args[^1]);
          Write(&end);
        end;
    end;

procedure Print(params args: array of object);

// Basic type conversion methods

function stoi(val: string): integer;
function &type(obj: object): System.Type;

// Basic sequence functions

function range(s: integer; e: integer; step: integer): sequence of integer;

function range(e: integer): sequence of integer;

function range(s: integer; e: integer): sequence of integer;

// Time management

function time_elapsed(): real;

implementation

function read_line(): string;
begin
  PABCSystem.Print();
  Result := PABCSystem.ReadlnString();
end;
  
procedure Print(params args: array of object);
begin
  !Print.Get().Print(args);
end;

function stoi(val: string): integer := integer.Parse(val);

function int(b: boolean): integer;
begin
  if b then
    Result := 1
  else
    Result := 0;
end;

function &type(obj: object): System.Type := obj.GetType();

function range(s: integer; e: integer; step: integer): sequence of integer;
begin
  Result := PABCSystem.Range(s, e - 1, step);
end;

function range(s: integer; e: integer): sequence of integer;
begin
  Result := PABCSystem.Range(s, e - 1);
end;

function range(e: integer): sequence of integer;
begin
  Result := PABCSystem.Range(0, e - 1);
end;

function time_elapsed(): real;
begin
 Result := DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1)).TotalSeconds;
end;

end.