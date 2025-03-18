import PABCSystem

def random() -> float:
    print(Random(0,99))
    return PABCSystem.random()
    
def randint(a: int, b: int) -> int:
    return PABCSystem.random(a, b)

random()