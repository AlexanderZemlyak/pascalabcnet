using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Collections.Generic;

using PythonScanner;
using PythonParser;

namespace PythonCompiler
{
    public class SimpleCompilerMain
    {
        public static void Main()
        {
            string FileName = @"..\..\..\a.txt";
            try
            {
                string Text = File.ReadAllText(FileName);

                Scanner scanner = new Scanner();
                scanner.SetSource(Text, 0);

                Parser parser = new Parser(scanner);

                var b = parser.Parse();
                if (!b)
                    Console.WriteLine("Error");
                else
                {
                    Console.WriteLine("Parsed");
                }
            }
            catch (FileNotFoundException)
            {
                Console.WriteLine("file {0} not found", FileName);
            }
            catch (Exception e)
            {
                Console.WriteLine("{0}", e);
            }

            Console.ReadLine();
        }

    }
}
