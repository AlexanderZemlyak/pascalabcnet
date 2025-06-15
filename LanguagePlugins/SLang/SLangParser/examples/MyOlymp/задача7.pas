{
  Задание 7. Дан массив из 10 целых чисел. Расположите элементы в порядке: сначала дающие
остаток 0 при делении на 3, затем остаток 1, затем остаток 2. Внутри каждой группы
отсортируйте элементы по возрастанию.
4 5 2 4 5 8 9 3 4 2
}
const
  N = 10;
begin
  
  // Если хочешь ввод — закомментируй строку выше и раскомментируй строку ниже:
   var a := ReadArrInteger(N);
  
  // Разделим на 3 группы
  var group0 := a.Where(x -> x mod 3 = 0).OrderBy(x -> x).ToArray;
  var group1 := a.Where(x -> x mod 3 = 1).OrderBy(x -> x).ToArray;
  var group2 := a.Where(x -> x mod 3 = 2).OrderBy(x -> x).ToArray;
  
  // Собираем результат
  var result := group0 + group1 + group2;
  
  Println('Отсортированный массив: ', result);
end.
