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
        private string programFilePath;
        private int currentLineSpaceCounter = 0;
        private int currentLineIndentLevel = 0;
        private int lineCounter = -1;
        private int previousIndentLevel = -1;

        public string CreatedFileName { get; private set; }
        public string CreatedFilePath { get; private set; }

        // количество пробелов соответствующее одному \t (в одном отступе)
        private const int indentSpaceNumber = 4;
        private const string indentLiteral = "Indent";
        private const string unindentLiteral = "Unindent";
        public const string createdFileNameAddition = "_indented";

        public IndentArranger(string path)
        {
            programFilePath = path;

            CreatedFileName =
                Path.GetFileNameWithoutExtension(path) + 
                createdFileNameAddition + Path.GetExtension(path);

            CreatedFilePath = Path.GetDirectoryName(path) + "\\" + CreatedFileName;
        }

        public void ArrangeIndents()
        {
            File.Delete(CreatedFilePath);
            string[] programLines = File.ReadAllLines(programFilePath);
            int lastNotEmptyLine = -1;
            foreach (var line in programLines)
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
                //Console.Write($"{lineCounter + 1}:\t");

                // пропуск строки не содержащей код 
                if (isEmptyLine)
                {
                    //Console.WriteLine("EmptyLine");
                    continue;
                }

                // количество отступов в текущей строке 
                currentLineIndentLevel = currentLineSpaceCounter / indentSpaceNumber;

                // количество пробелов в строке является некорректным 
                // (не соответствует количеству пробелов в строке с любым отступом) 
                if (currentLineSpaceCounter % indentSpaceNumber != 0)
                {
                    throw new NotPossibleIndentException();
                }
                // текущий отступ соответствует увеличению на больше чем один отступ 
                else if (currentLineIndentLevel > previousIndentLevel + 1)
                {
                    throw new ManyIndentsAdditionException();
                }
                // текущий отступ соответствует увеличению на один отступ 
                else if (currentLineIndentLevel == previousIndentLevel + 1)
                {
                    //Console.Write(indentLiteral);
                    if (lastNotEmptyLine != -1)
                        programLines[lastNotEmptyLine] += " " + indentLiteral;
                    // закомментировать ветку else если нет блока оборачивающего всю программу
                    else
                        File.AppendAllText(CreatedFilePath, indentLiteral + "\n");
                }
                // текущий отступ соответствует уменьшению на один или несколько отступов
                else if (currentLineIndentLevel < previousIndentLevel)
                {
                    //Console.Write(
                        //string.Concat(Enumerable.Repeat(unindentLiteral + " ", previousIndentLevel - currentLineIndentCounter)));
                    programLines[lastNotEmptyLine] +=
                        string.Concat(Enumerable.Repeat(" " + unindentLiteral, previousIndentLevel - currentLineIndentLevel));
                }
                // текущий отступ  соответствует предыдущему отступу 
                else if (currentLineIndentLevel == previousIndentLevel)
                {
                    //Console.Write("Nothing");
                }

                previousIndentLevel = currentLineIndentLevel;
                lastNotEmptyLine = lineCounter;
                //Console.WriteLine();
            }

            // закрытие всех отступов в конце файла
            // (убрать "+ 1" если нет блока оборачивающего всю программу)
            programLines[lastNotEmptyLine] +=
                string.Concat(Enumerable.Repeat(" " + unindentLiteral, currentLineIndentLevel + 1));

            //Console.WriteLine("EOF:\t" + 
            //    string.Concat(Enumerable.Repeat(unindentLiteral + " ", currentLineIndentCounter + 1)));

            File.AppendAllLines(CreatedFilePath, programLines);
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
