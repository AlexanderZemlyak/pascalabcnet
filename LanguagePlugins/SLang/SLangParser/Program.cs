using System;
using System.IO;
using System.Text;
using SLangParserYacc;
using static System.Console;

namespace SLangParser {
    internal class Program {
        static void Main(string[] args) {
            string fileName = "/Users/controldata/GitHub/pascalabcnet/LanguagePlugins/SLang/SLangParser/InputCode.slang";
            string inputCode = "";
            try {
                using (StreamReader sr = new StreamReader(fileName)) {
                    string line;
                    while ((line = sr.ReadLine()) != null) {
                        inputCode += line;
                    }
                }
            }
            catch (Exception e) {
                WriteLine("Ошибка: " + e.Message);
            }

            WriteLine(inputCode);

            var slangParser = new SLangLanguageParser();
            var root = slangParser.Parse(inputCode, fileName);

            try {
                WriteLine("Парсинг завершен успешно!");
                WriteLine("Дерево AST:");
            }
            catch (Exception ex) {
                WriteLine("Ошибка парсинга: " + ex.Message);
            }
        }
    }
}