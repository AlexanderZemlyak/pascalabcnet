uses DSLExample;

procedure LogMessage(msg: string);
begin
  println(msg);
end;

begin
  CheckTaskT('задача23');
  CheckTaskT('задача1');
  CheckTaskT('задача2');
  LogMessage('Начало выполнения основной задачи');
  {
  var n := 20000;
  var i := 1;
  var s := 0.0;
  while i < n do
  begin
    var j := 1;
    while j < n do
    begin
      s += 1.0/i/j;
      j+=1;
    end;
    i += 1;
  end;
  Println(s);
  Println(Milliseconds)
  }
end.