{
  Задание 8. Дана строка слов, разделенных пробелами. Найдите два самых часто встречаемых
слова. Если есть несколько слов с одинаковой частотой, выберите первые два по
алфавиту.
s s s s s d d d d s d s a d s fa w f aw
}
begin
  var s := ReadString;
  s.ToWords.EachCount.OrderByDescending(k -> k.Value).ThenBy(k -> k.Key).Take(2).Select(k -> k.Key).Print();
end.
