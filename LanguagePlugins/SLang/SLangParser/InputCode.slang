# Пример функции в SLang
def greet(name: str) -> str:
    if name:
        return "Hello, " + name
    else:
        return "Hello, World!"

# Использование функции
user_name = "Alice"
print(greet(user_name))