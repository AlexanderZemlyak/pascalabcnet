{
  Задание 3. Дано целое положительное трехзначное число. Переставьте его цифры в обратном
порядке. Выведите получившееся число.
}
var
  num, hundreds, tens, units, reversed: Integer;

begin
  Write('Введите трёхзначное число: ');
  Readln(num);
  
  if (num >= 100) and (num <= 999) then
  begin
    hundreds := num div 100;
    tens := (num div 10) mod 10;
    units := num mod 10;
    
    reversed := units * 100 + tens * 10 + hundreds;
    
    Writeln('Число в обратном порядке: ', reversed);
  end
  else
    Writeln('Ошибка: введите трёхзначное число от 100 до 999.');
end.