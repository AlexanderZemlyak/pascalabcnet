task "Olymp2-Task01" {
  input {
    CheckData(cInt * 3);
    let a = cInt;
  }

  solution {
    let d = a + 2;
  }

  tests {
    GenerateTests(10, tInt * 3);
  }

  output {
    CheckOutput(a);
  }
}
