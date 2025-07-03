{$HiddenIdents}
unit SLangSystem;

// MARK: - Interfaces

interface

uses PABCSystem, LightPT;

// MARK: - Типы

/// Целый тип для проверки ввода-вывода
function ТипЦел: System.Type;
/// Вещественный тип для проверки ввода-вывода
function ТипВещ: System.Type;
/// Строковый тип для проверки ввода-вывода
function ТипСтрока: System.Type;
/// Логический тип для проверки ввода-вывода
function ТипБул: System.Type;
/// Символьный тип для проверки ввода-вывода
function ТипСимвол: System.Type;

// MARK: - Случайные значения

function Случайное(a,b: integer): integer;
function Случайное(n: integer): integer;
function Случайное: real;
function Случайное(a,b: real): real;
function СлучайноеВещественное(a,b: real; digits: integer := 1): real;
function СлучайныйСимвол(a,b: char): char;
function Случайное(diap: IntRange): integer;
function Случайное(diap: RealRange): real;
function СлучайныйСимвол(diap: CharRange): char;

// MARK: - Случайные пары и тройки

function Случайные2(a,b: integer): (integer,integer);
function Случайные2(a,b: real): (real,real);
function Случайные2(a,b: char): (char,char);
function Случайные2(diap: IntRange): (integer,integer);
function Случайные2(diap: RealRange): (real,real);
function Случайные2(diap: CharRange): (char,char);

function Случайные3(a,b: integer): (integer,integer,integer);
function Случайные3(a,b: real): (real,real,real);
function Случайные3(a,b: char): (char,char,char);
function Случайные3(diap: IntRange): (integer,integer,integer);
function Случайные3(diap: RealRange): (real,real,real);
function Случайные3(diap: CharRange): (char,char,char);

// MARK: - Случайные массивы и матрицы

function МассивСлучайныхЦелых(n,a,b: integer): array of integer;
function МассивСлучайныхЦелых(n: integer): array of integer;
function МассивСлучайныхВещественных(n: integer; a,b: real; digits: integer := 1): array of real;
function МассивСлучайныхВещественных(n: integer; digits: integer := 1): array of real;

function МатрицаСлучайныхЦелых(m,n,a,b: integer): array[,] of integer;
function МатрицаСлучайныхЦелых(m,n: integer): array[,] of integer;
function МатрицаСлучайныхВещественных(m,n: integer; a,b: real; digits: integer := 2): array[,] of real;
function МатрицаСлучайныхВещественных(m,n: integer): array[,] of real;

// MARK: - Ввод (чтение)

function ВводЦелого(prompt: string): integer;
function ВводЦелогоLn(prompt: string): integer;
function Ввод2Целых(prompt: string): (integer,integer);
function Ввод2ЦелыхLn(prompt: string): (integer,integer);
function Ввод3Целых(prompt: string): (integer,integer,integer);
function Ввод3ЦелыхLn(prompt: string): (integer,integer,integer);
function Ввод4Целых(prompt: string): (integer,integer,integer,integer);
function Ввод4ЦелыхLn(prompt: string): (integer,integer,integer,integer);

function ВводВещественного(prompt: string): real;
function ВводВещественногоLn(prompt: string): real;
function Ввод2Вещественных(prompt: string): (real,real);
function Ввод2ВещественныхLn(prompt: string): (real,real);
function Ввод3Вещественных(prompt: string): (real,real,real);
function Ввод3ВещественныхLn(prompt: string): (real,real,real);
function Ввод4Вещественных(prompt: string): (real,real,real,real);
function Ввод4ВещественныхLn(prompt: string): (real,real,real,real);

function ВводСимвола(prompt: string): char;
function ВводСимволаLn(prompt: string): char;
function ВводСтроки(prompt: string): string;
function ВводСтрокиLn(prompt: string): string;

// MARK: - Вывод (печать)

procedure Печать(params args: array of object);
procedure ПечатьСтроку(params args: array of object);
procedure Печать(o: object);
procedure Печать(s: string);
procedure Печать(c: char);

procedure ЦветСообщение(msg: string; color: MessageColorT);
procedure ЦветСообщение(msg: string);

// MARK: - Проверки ввода/вывода

procedure ПроверитьДанные(ВходИсходный: array of System.Type := nil; 
                           ВыходИсходный: array of System.Type := nil; 
                           Вход: array of System.Type := nil);

procedure ПроверитьВводТипы(a: array of System.Type);
procedure ПроверитьВводПустой;
procedure ПроверитьВводИсходный;
procedure ПроверитьКоличествоВвода(n: integer);
procedure ПроверитьКоличествоВвода2(i: integer);

procedure ПроверитьВывод(params arr: array of object);
procedure ПроверитьВывод(lst: ObjectList);
procedure ПроверитьВыводБезСообщения(params res: array of object);
procedure ПроверитьВыводБезСообщения(lst: ObjectList);

procedure ПроверитьВыводПоследующий(params res: array of object);
procedure ПроверитьВыводПоследующий(lst: ObjectList);
procedure ПроверитьВыводПоследующийБезСообщения(params res: array of object);
procedure ПроверитьВыводПоследующийБезСообщения(lst: ObjectList);

function целое(i: integer): integer;
function вещественное(i: integer): real;
function символ(i: integer): char;
function булево(i: integer): boolean;

function Цел(i: integer): integer;
function Вещ(i: integer): real;
function Стр(i: integer): string;
function Лог(i: integer): boolean;
function Сим(i: integer): char;

function Цел(): integer;
function Вещ(): real;
function Стр(): string;
function Лог(): boolean;
function Сим(): char;

function Цел2(): (integer,integer);
function Вещ2(): (real,real);

function МассивЦелых(n: integer): array of integer;
function МассивВещественных(n: integer): array of real;
function МассивЛогических(n: integer): array of boolean;
function МассивСимволов(n: integer): array of char;
function МассивСтрок(n: integer): array of string;

// MARK: - Проверка последовательностей

procedure ПроверитьВыводПоследовательность(seq: sequence of integer);
procedure ПроверитьВыводПоследовательность(seq: sequence of real);
procedure ПроверитьВыводПоследовательность(seq: sequence of string);
procedure ПроверитьВыводПоследовательность(seq: sequence of char);
procedure ПроверитьВыводПоследовательность(seq: sequence of boolean);
procedure ПроверитьВыводПоследовательность(seq: ObjectList);

procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of integer);
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of real);
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of string);
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of char);
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of boolean);
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: ObjectList);

// MARK: - Вспомогательные DSL

function ТолькоЧисла(): integer;
function ТолькоЧислаИБулевы(): integer;

// MARK: - Генерация тестовых данных

function ТестЦел(a: integer := 1; b: integer := 10): TestCell;
function ТестВещ(a: real := 1; b: real := 10; разрядов: integer := 0): TestCell;
function ТестСимвол(a: char := 'а'; b: char := 'я'): TestCell;
function ТестБулево: TestCell;

procedure СгенерироватьТесты(cnt: integer; pattern: sequence of TestCell);
procedure СгенерироватьТесты(params a: array of integer);
procedure СгенерироватьТесты(params a: array of real);
procedure СгенерироватьТесты(params a: array of string);
procedure СгенерироватьТесты(params a: array of char);
procedure СгенерироватьТесты(params a: array of boolean);
procedure СгенерироватьТесты<T1,T2>(params a: array of (T1,T2));
procedure СгенерироватьТесты<T1,T2,T3>(params a: array of (T1,T2,T3));
procedure ДобавитьТестовыеДанные(params data: array of integer);
procedure ДобавитьТестовыеДанные(params data: array of real);
function GetValue(kv: KeyValuePair<string, integer>): integer;
function GetKey(kv: KeyValuePair<string, integer>): string;

// MARK: - Implementations

implementation

function GetValue(kv: KeyValuePair<string, integer>): integer;
begin
  Result := kv.Value;
end;
function GetKey(kv: KeyValuePair<string, integer>): string;
begin
  Result := kv.Key;
end;

// MARK: - Типы

/// Целый тип для проверки ввода-вывода
function ТипЦел := typeof(integer);
/// Вещественный тип для проверки ввода-вывода
function ТипВещ := typeof(real);
/// Строковый тип для проверки ввода-вывода
function ТипСтрока := typeof(string);
/// Логический тип для проверки ввода-вывода
function ТипБул := typeof(boolean);
/// Символьный тип для проверки ввода-вывода
function ТипСимвол := typeof(char);

// MARK: - Random

function Случайное(a,b: integer): integer := Random(a,b);
function Случайное(n: integer): integer := Random(n);
function Случайное: real := Random;
function Случайное(a,b: real): real := Random(a,b);
function СлучайноеВещественное(a,b: real; digits: integer): real := RandomReal(a,b,digits);
function СлучайныйСимвол(a,b: char): char := Random(a,b);
function Случайное(diap: IntRange): integer := Random(diap);
function Случайное(diap: RealRange): real := Random(diap);
function СлучайныйСимвол(diap: CharRange): char := Random(diap);

// MARK: - пары/тройки

function Случайные2(a,b: integer): (integer,integer) := Random2(a,b);
function Случайные2(a,b: real): (real,real) := Random2(a,b);
function Случайные2(a,b: char): (char,char) := Random2(a,b);
function Случайные2(diap: IntRange): (integer,integer) := Random2(diap);
function Случайные2(diap: RealRange): (real,real) := Random2(diap);
function Случайные2(diap: CharRange): (char,char) := Random2(diap);

function Случайные3(a,b: integer): (integer,integer,integer) := Random3(a,b);
function Случайные3(a,b: real): (real,real,real) := Random3(a,b);
function Случайные3(a,b: char): (char,char,char) := Random3(a,b);
function Случайные3(diap: IntRange): (integer,integer,integer) := Random3(diap);
function Случайные3(diap: RealRange): (real,real,real) := Random3(diap);
function Случайные3(diap: CharRange): (char,char,char) := Random3(diap);

// MARK: - массивы/матрицы

function МассивСлучайныхЦелых(n,a,b: integer): array of integer := ArrRandomInteger(n,a,b);
function МассивСлучайныхЦелых(n: integer): array of integer := ArrRandomInteger(n);
function МассивСлучайныхВещественных(n: integer; a,b: real; digits: integer): array of real :=
  ArrRandomReal(n,a,b,digits);
function МассивСлучайныхВещественных(n: integer; digits: integer): array of real :=
  ArrRandomReal(n,digits);

function МатрицаСлучайныхЦелых(m,n,a,b: integer): array[,] of integer := MatrRandomInteger(m,n,a,b);
function МатрицаСлучайныхЦелых(m,n: integer): array[,] of integer := LightPT.MatrRandomInteger(m,n);
function МатрицаСлучайныхВещественных(m,n: integer; a,b: real; digits: integer): array[,] of real :=
  MatrRandomReal(m,n,a,b,digits);
function МатрицаСлучайныхВещественных(m,n: integer): array[,] of real := LightPT.MatrRandomReal(m,n);

// MARK: - Реализация: ввод/вывод

function ВводЦелого(prompt: string): integer := ReadInteger(prompt);
function ВводЦелогоLn(prompt: string): integer := ReadlnInteger(prompt);
function Ввод2Целых(prompt: string): (integer,integer) := ReadInteger2(prompt);
function Ввод2ЦелыхLn(prompt: string): (integer,integer) := ReadlnInteger2(prompt);
function Ввод3Целых(prompt: string): (integer,integer,integer) := ReadInteger3(prompt);
function Ввод3ЦелыхLn(prompt: string): (integer,integer,integer) := ReadlnInteger3(prompt);
function Ввод4Целых(prompt: string): (integer,integer,integer,integer) := ReadInteger4(prompt);
function Ввод4ЦелыхLn(prompt: string): (integer,integer,integer,integer) := ReadlnInteger4(prompt);

function ВводВещественного(prompt: string): real := ReadReal(prompt);
function ВводВещественногоLn(prompt: string): real := ReadlnReal(prompt);
function Ввод2Вещественных(prompt: string): (real,real) := ReadReal2(prompt);
function Ввод2ВещественныхLn(prompt: string): (real,real) := ReadlnReal2(prompt);
function Ввод3Вещественных(prompt: string): (real,real,real) := ReadReal3(prompt);
function Ввод3ВещественныхLn(prompt: string): (real,real,real) := ReadlnReal3(prompt);
function Ввод4Вещественных(prompt: string): (real,real,real,real) := ReadReal4(prompt);
function Ввод4ВещественныхLn(prompt: string): (real,real,real,real) := ReadlnReal4(prompt);

function ВводСимвола(prompt: string): char := ReadChar(prompt);
function ВводСимволаLn(prompt: string): char := ReadlnChar(prompt);
function ВводСтроки(prompt: string): string := ReadString(prompt);
function ВводСтрокиLn(prompt: string): string := ReadlnString(prompt);

// MARK: - вывод
procedure Печать(params args: array of object); begin Print(args) end;
procedure ПечатьСтроку(params args: array of object); begin Println(args) end;

procedure Печать(o: object); begin Print(o) end;
procedure Печать(s: string); begin Print(s) end;
procedure Печать(c: char); begin Print(c) end;

procedure ЦветСообщение(msg: string; color: MessageColorT); begin ColoredMessage(msg,color) end;
procedure ЦветСообщение(msg: string); begin ColoredMessage(msg) end;

// MARK: - Реализация: проверки ввода/вывода

procedure ПроверитьДанные(ВходИсходный: array of System.Type; 
                           ВыходИсходный: array of System.Type; 
                           Вход: array of System.Type );
begin
  CheckData(InitialInput := ВходИсходный,
            InitialOutput := ВыходИсходный,
            Input := Вход);
end;

procedure ПроверитьВводТипы(a: array of System.Type); begin CheckInputTypes(a) end;
procedure ПроверитьВводПустой; begin CheckInputIsEmpty end;
procedure ПроверитьВводИсходный; begin CheckInputIsInitial end;
procedure ПроверитьКоличествоВвода(n: integer); begin CheckInputCount(n) end;
procedure ПроверитьКоличествоВвода2(i: integer); begin CheckInput2Count(i) end;

procedure ПроверитьВывод(params arr: array of object); begin CheckOutput(arr) end;
procedure ПроверитьВывод(lst: ObjectList); begin CheckOutput(lst) end;
procedure ПроверитьВыводБезСообщения(params res: array of object); begin CheckOutputSilent(res) end;
procedure ПроверитьВыводБезСообщения(lst: ObjectList); begin CheckOutputSilent(lst) end;

procedure ПроверитьВыводПоследующий(params res: array of object); begin CheckOutputAfterInitial(res) end;
procedure ПроверитьВыводПоследующий(lst: ObjectList); begin CheckOutputAfterInitial(lst) end;
procedure ПроверитьВыводПоследующийБезСообщения(params res: array of object);
begin CheckOutputAfterInitialSilent(res) end;
procedure ПроверитьВыводПоследующийБезСообщения(lst: ObjectList);
begin CheckOutputAfterInitialSilent(lst) end;

// MARK: - последовательности

procedure ПроверитьВыводПоследовательность(seq: sequence of integer); begin CheckOutputSeq(seq) end;
procedure ПроверитьВыводПоследовательность(seq: sequence of real);    begin CheckOutputSeq(seq) end;
procedure ПроверитьВыводПоследовательность(seq: sequence of string);  begin CheckOutputSeq(seq) end;
procedure ПроверитьВыводПоследовательность(seq: sequence of char);    begin CheckOutputSeq(seq) end;
procedure ПроверитьВыводПоследовательность(seq: sequence of boolean); begin CheckOutputSeq(seq) end;
procedure ПроверитьВыводПоследовательность(seq: ObjectList);       begin CheckOutputSeq(seq) end;

procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of integer);
begin CheckOutputSeqSilent(seq) end;
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of real);
begin CheckOutputSeqSilent(seq) end;
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of string);
begin CheckOutputSeqSilent(seq) end;
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of char);
begin CheckOutputSeqSilent(seq) end;
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: sequence of boolean);
begin CheckOutputSeqSilent(seq) end;
procedure ПроверитьВыводПоследовательностьБезСообщения(seq: ObjectList);
begin CheckOutputSeqSilent(seq) end;

// MARK: - Проверка вводимых типов

function целое(i: integer): integer := LightPT.Int(i);
function вещественное(i: integer): real := LightPT.Re(i);
function символ(i: integer): char := LightPT.Chr(i);
function булево(i: integer): boolean := LightPT.Boo(i);

function Цел(i: integer): integer := Int(i);
function Вещ(i: integer): real := Re(i);
function Стр(i: integer): string := Str(i);
function Лог(i: integer): boolean := Boo(i);
function Сим(i: integer): char := Chr(i);

function Цел: integer := Int;
function Вещ: real    := Re;
function Стр: string  := Str;
function Лог: boolean := Boo;
function Сим: char    := Chr;

function Цел2(): (integer,integer) := Int2;
function Вещ2(): (real,real)       := Re2;

function МассивЦелых(n: integer): array of integer := IntArr(n);
function МассивВещественных(n: integer): array of real := ReArr(n);
function МассивЛогических(n: integer): array of boolean := BooArr(n);
function МассивСимволов(n: integer): array of char := ChrArr(n);
function МассивСтрок(n: integer): array of string := StrArr(n);

// MARK: - Реализация: вспомогательные DSL

function ТолькоЧисла(): integer; begin FilterOnlyNumbers; Result := 0 end;
function ТолькоЧислаИБулевы(): integer; begin FilterOnlyNumbersAndBools; Result := 0 end;

// MARK: - Генерация тестовых данных

function ТестЦел(a: integer; b: integer): TestCell;
begin
  Result := tInt(a, b);
end;

function ТестВещ(a: real; b: real; разрядов: integer): TestCell;
begin
  Result := tRe(a, b, разрядов);
end;

function ТестСимвол(a: char; b: char): TestCell;
begin
  Result := tChr(a, b);
end;

function ТестБулево: TestCell;
begin
  Result := tBoo;
end;

procedure СгенерироватьТесты(cnt: integer; pattern: sequence of TestCell);
begin GenerateTests(cnt, pattern.ToArray) end;
procedure СгенерироватьТесты(params a: array of integer);
begin GenerateTests(a) end;
procedure СгенерироватьТесты(params a: array of real);
begin GenerateTests(a) end;
procedure СгенерироватьТесты(params a: array of string);
begin GenerateTests(a) end;
procedure СгенерироватьТесты(params a: array of char);
begin GenerateTests(a) end;
procedure СгенерироватьТесты(params a: array of boolean);
begin GenerateTests(a) end;
procedure СгенерироватьТесты<T1,T2>(params a: array of (T1,T2));
begin GenerateTests(a) end;
procedure СгенерироватьТесты<T1,T2,T3>(params a: array of (T1,T2,T3));
begin GenerateTests(a) end;

procedure ДобавитьТестовыеДанные(params data: array of integer);
begin GenerateTests(data) end;

procedure ДобавитьТестовыеДанные(params data: array of real);
begin GenerateTests(data) end;
end.