{
  Задание 4. Даны целое число n > 2 и массив из n целых чисел. Определите, образуют ли
элементы массива возрастающую арифметическую прогрессию. Выведите YES или NO.
}
begin
  var n := ReadInteger();
  var a := ReadArrInteger(n);
  
  var d := a[1] - a[0];
  if d <= 0 then
  begin
    Writeln('NO');
    exit;
  end;
  
  for var i := 2 to n - 1 do
    if a[i] - a[i-1] <> d then
    begin
      Writeln('NO');
      exit;
    end;
    
  Print('YES');
end.