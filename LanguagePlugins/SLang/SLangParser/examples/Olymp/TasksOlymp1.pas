unit TasksOlymp1;

uses LightPT;

procedure CheckTaskT(name: string);
begin
  ClearOutputListFromSpaces; 

  case name of
  'Olymp2-Task01': begin
    FilterOnlyNumbersAndBools;
    CheckData(Empty);
    var d := DateTime.Now;
    CheckOutput(d.Year, d.Month, d.Day);
  end;
  'Olymp2-Task02': begin
    FilterOnlyNumbersAndBools;
    CheckData(Input := cInt*3);
    
    var a := Int(0);
    var b := Int(1);
    var c := Int(2);
    var res: integer;
    
    if (a = b) and (b = c) then
      res := 1
    else if (a = b) or (b = c) or (a = c) then
      res := 2
    else
      res := 3;
    
    GenerateTests(10, tInt(1,10)*3);
    CheckOutput(res);

  end;
  'Olymp2-Task03': begin
    FilterOnlyNumbersAndBools;
    CheckData(Input := |cInt|);
    var a := Int(0);
    GenerateTests(10,tInt(100,999)*1);
    CheckOutput(a.ToString.Inverse.ToInteger);
  end;
  'Olymp2-Task04': begin
    var n := Int;
    var a := IntArr(n);
    CheckData(Input := |cInt|*(n+1));
    TestCount := 10;
    GenerateTestData := tnum -> begin
      var n := Random(2,4);
      var a := ArrRandomInteger(n);
      InputList.AddTestData(|n|+a);
    end;
    var b := a.Zip(a[1:],(x,y) -> y - x).ToArray;
    CheckOutput((b[0] > 0) and b.All(x -> x = b[0]) ? 'YES' : 'NO');
  end;
  'Olymp2-Task05': begin
    var n := 10;
    CheckData(Input := |cInt|*n);
    var a := IntArr(n);
    var mn_idx := a.IndexMin; 
  
    var b := a[mn_idx:] + a[:mn_idx];

    TestCount := 10;
    GenerateTestData := tnum -> begin
      var a := ArrRandomInteger(n);
      InputList.AddTestData(a);
    end;
    CheckOutput(b);
  end;
  'Olymp2-Task06': begin
    var n := 10;
    CheckData(Input := |cInt|*(n+1));
    var x := Int;
    var a := IntArr(n);
    var ob := ObjectList.New;
    for var i := 0 to 9 do
      for var j := i + 1 to 9 do
        if a[i] + a[j] = x then
        begin
          ob.Add(i);
          ob.Add(j);
        end;
    GenerateTests(10, tInt * (n+1));
    CheckOutput(ob);
  end;
  'Olymp2-Task07': begin
    var n := 10;
    CheckData(Input := |cInt|*n);
    var a := IntArr(n);
    GenerateTests(10, tInt * n);
    CheckOutput(a.Where(x -> x mod 3 = 0).Order + a.Where(x -> x mod 3 = 1).Order + a.Where(x -> x mod 3 = 2).Order);
  end;
  'Olymp2-Task08': begin
    CheckData(Input := |cStr|);
    var s := Str;
    GenerateTests('d c b a d','d c b a d b');
    var d := s.ToWords.EachCount.OrderByDescending(k -> k.Value).ThenBy(k -> k.Key);
    
    CheckOutput(d.Take(2).Select(k -> k.Key));
  end;
  'Olymp2-Task09': begin
    var n := 10;
    CheckData(Input := |cRe|*n);
    var a := ReArr(n);
    
    TestCount := 2;
    GenerateTestData := tnum -> begin
      
      var a := |1.2, 3.3, 2.4, 5.1, 4.5, 7.2, 6.9, 9.0, 8.4, 10.5|;
      if tnum = 1 then
        a := |2.4, 4.2,3.6, 6.0, 5.4, 8.1, 7.5, 10.8, 9.3, 12.6|;
      InputList.AddTestData(a);
    end;

    var b := Copy(a);
    for var i := 1 to a.Length-2 do
      b[i] := a[i-1:i+2].Average;
    
    CheckOutput(b);
  end;
  'Olymp1-Task01': begin
    CheckData(Empty);
    var d := DateTime.Now;
    CheckOutput(d.Day, d.Month, d.Year);
  end;
  'Olymp1-Task02': begin
    CheckData(Input := cInt*2);
    var a := Int(0);
    var b := Int(1);
    var res: integer;
    if (b <> 0) and a.Divs(b) then
      res := a div b
    else res := 0;
    GenerateTests(10,tInt(0,10)*2);
    CheckOutput(res);
  end;
  'Olymp1-Task03': begin
    CheckData(Input := cInt*2);
    var a := Int(0);
    var b := Int(1);
    var res: integer;
    if a < b then
      res := -1
    else if a = b 
      then res := 0
    else res := 1;
    GenerateTests(10,tInt(0,10)*2);
    CheckOutput(res);
  end;
  'Olymp1-Task04': begin
    CheckData(Input := |cInt|);
    var n := Int(0);
    var res: integer;
    if n mod 4 = 0 then
      res := n div 4
    else res := n div 4 + 1;
    GenerateTests(10,tInt(0,100)*1);
    CheckOutput(res);
  end;
  'Olymp1-Task05': begin
    CheckData(Input := |cInt|);
    var a := Int(0);
    var c1 := a div 10;
    var c2 := a mod 10;
    var res: integer;
    if c1 < c2 then 
      res := a
    else res := c2 * 10 + c1;
    GenerateTests(10,tInt(10,99)*1);
    CheckOutput(res);
  end;
  'Olymp1-Task06': begin
    CheckData(Input := |cInt|*3);
    var (a,b,c) := IntArr(3);
    var aa := Arr(a,b,c);
    var max := aa.Max;
    var sum := aa.Sum - max;
    var res := Abs(max - sum) <= 3;
    GenerateTests(10,tInt(1,9)*3);
    CheckOutput(res);
  end;
  'Olymp1-Task07': begin
    CheckData(Input := |cInt|*3);
    var (a,b,c) := IntArr(3);
    var res: integer;
    if (a < b) and (b < c) then
      res := 0
    else if (c < a) and ((b < c) or (a < b)) then
      res := 2
    else
      res := 1;
    TestCount := 6;
    GenerateTestData := tnum -> begin
      var (a,b,c) := (1,2,3);
      case tnum of
        1: (a,b,c) := (1,2,3);
        2: (a,b,c) := (2,1,3);
        3: (a,b,c) := (1,3,2);
        4: (a,b,c) := (2,3,1);
        5: (a,b,c) := (3,2,1);
        6: (a,b,c) := (3,1,2);
      end;
      InputList.AddTestData(|a,b,c|);
    end;
    CheckOutput(res);
  end;
  'Olymp1-Task08': begin
    CheckData(Input := |cInt|);
    var n := Int;
    var L := new List<integer>;
    for var i := 3 to n step 2 do  
      loop i do
        L.Add(i);
    GenerateTests(3,5,7,9,11,13,15,17,19);
    CheckOutput(L);
  end;
  'Olymp1-Task09': begin
    CheckData(Input := |cInt|);
    var n := Int;
    var L := new List<integer>;
    for var x := 1 to n do
      for var y := 1 to n do
        if x + y = n then
        begin
          L.Add(x); L.Add(y);
        end;

    GenerateTests(3,5,7,9,11,13,15,17,19);
    CheckOutput(L);
  end;
  end;
  
end;

initialization
  CheckTask := CheckTaskT;
finalization
end.