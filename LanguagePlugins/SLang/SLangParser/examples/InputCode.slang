use priority_queue;

fn greet() -> float {
    let s = 0.0;
    let i = 1;
    while i < 100000000 {
      s += 1.0 / i;
      i += 1;
    }
    return s;
}

fn greet2() -> float {
    let stime = time_elapsed();
    let s = 0.0;
    let i = 1;
    let n = 20000;
    while i < n {
      let j = 1;
      while j < n {
        s += 1.0 / i / j;
        j += 1;
      }
      i += 1;
    }
    print(time_elapsed() - stime);
    let a = [[0], [0], [4]];
    let cg = ([0], [0]);
    return s;
}
print(greet2());
make_tree();