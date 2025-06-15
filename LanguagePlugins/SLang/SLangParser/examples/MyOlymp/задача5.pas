{
  Задание 5. Дан массив из 10 целых чисел. Циклически сдвигайте элементы влево, пока первым не
окажется первый минимальный элемент. Выведите полученный массив.
}
begin
  var N := 10;
  var a := ReadArrInteger(n);

  var mn := a.IndexMin; // индекс первого минимального элемента :contentReference[oaicite:1]{index=1}

  // Циклический сдвиг: пропускаем mn элементов, затем берем первые mn, и объединяем
  var b := a.Skip(mn).Concat(a.Take(mn)).ToArray; // :contentReference[oaicite:2]{index=2}

  b.Println();
end.