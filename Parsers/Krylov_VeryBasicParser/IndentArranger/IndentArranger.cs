using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace IndentArranger
{   
    public class IndentArranger
    {
        private string path;
        private int currentLineSpaceCounter = 0;
        private int currentLineIndentCounter = 0;
        private int lineCounter = 0;
        private int previousIndentLevel = -1;

        // количество пробелов соответствующее одному \t (в одном отступе)
        private const int indentSpaceNumber = 4;
        private const string indentLiteral = "Indent";
        private const string unindentLiteral = "Unindent";

        public IndentArranger(string path)
        {
            this.path = path;
        }

        public void ArrangeIndents()
        {
            var lines = File.ReadLines(path);
            foreach (var line in lines)
            {
                lineCounter++;
                bool isEmptyLine = true; // строка не содержит символов кроме 'space'\t\n\r
                currentLineSpaceCounter = 0;

                foreach (var chr in line)
                {
                    switch (chr)
                    {
                        case ' ':
                            currentLineSpaceCounter++;
                            break;
                        case '\t':
                            // один \t выравнивает до следующего отступа
                            currentLineSpaceCounter += indentSpaceNumber;
                            currentLineSpaceCounter &= ~(indentSpaceNumber - 1);
                            break;
                        default:
                            isEmptyLine = false;
                            break;
                    }
                    if (!isEmptyLine) break;
                }

                // вывод номера текущей строки для дебага
                Console.Write($"{lineCounter}:\t");

                // пропуск строки не содержащей код 
                if (isEmptyLine)
                {
                    Console.WriteLine("EmptyLine");
                    continue;
                }

                // количество отступов в текущей строке 
                currentLineIndentCounter = currentLineSpaceCounter / indentSpaceNumber;

                // количество пробелов в строке является некорректным 
                // (не соответствует количеству пробелов в строке с любым отступом) 
                if (currentLineSpaceCounter % indentSpaceNumber != 0)
                {
                    throw new NotPossibleIndentException();
                }
                // текущий отступ соответствует увеличению на больше чем один отступ 
                else if (currentLineIndentCounter > previousIndentLevel + 1)
                {
                    throw new ManyIndentsAdditionException();
                }
                // текущий отступ соответствует увеличению на один отступ 
                else if (currentLineIndentCounter == previousIndentLevel + 1)
                {
                    Console.Write(indentLiteral);
                    previousIndentLevel = currentLineIndentCounter;
                }
                // текущий отступ соответствует уменьшению на один или несколько отступов
                else if (currentLineIndentCounter < previousIndentLevel)
                {
                    for (int i = currentLineIndentCounter; i < previousIndentLevel; ++i)
                        Console.Write(unindentLiteral + " ");
                    previousIndentLevel = currentLineIndentCounter;
                }
                // текущий отступ  соответствует предыдущему отступу 
                else if (currentLineIndentCounter == previousIndentLevel)
                {
                    Console.Write("Nothing");
                }

                Console.WriteLine();
            }

            Console.Write("EOF:\t");
            // закрытие всех отступов в конце файла
            for (int i = 0; i <= currentLineIndentCounter; ++i)
                Console.Write("Unindent ");
            Console.WriteLine();
        }
    }


    class Program
    {
        static void Main(string[] args)
        {
            string path;

            // только для дебага
            if (args.Length == 0)
            {
                path = "../../test.txt";
            }
            else
            {
                path = args[0];
            }

            try
            {
                IndentArranger ia = new IndentArranger(path);
                ia.ArrangeIndents();
            }
            catch (IndentArrangerException iae)
            {
                Console.Write("\r");
                Console.WriteLine(iae.Message);
            }
            catch (IOException ioe)
            {
                Console.WriteLine(ioe.Message);
            }
        }
    }
}
