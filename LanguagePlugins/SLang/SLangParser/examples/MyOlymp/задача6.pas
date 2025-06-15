{
  Задание 6. Даны целое число X и массив из 10 целых чисел. Выведите все пары индексов (i, j)
такие, что i < j и сумма элементов на этих позициях равна X. Пары выводите в порядке
возрастания i, а при равных i - в порядке возрастания j.
Например 1 2 3 4 5 1 2 3 4 5
}
const
  N = 10;

begin
  var X := ReadInteger;
  var A := ReadArrInteger(N);
  for var i := 0 to N - 2 do
    for var j := i + 1 to N - 1 do
      if A[i] + A[j] = X then
        Writeln(i, ' ', j);
end.