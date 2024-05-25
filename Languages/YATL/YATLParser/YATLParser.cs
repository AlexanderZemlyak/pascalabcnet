﻿/*using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Collections.Generic;
using PascalABCCompiler.SyntaxTree;
using PascalABCCompiler.Parsers;
using PascalABCCompiler.ParserTools;
using PascalABCCompiler.Errors;
using YATLParserYacc;
using YATL;


namespace YATL
{
    public class YATLGPPGParserHelper
    {
        private List<Error> Errs;
        private List<CompilerWarning> Warnings;
        private string FileName;
        public bool build_tree_for_formatter = false;
        public List<string> DefinesList = null;

        public YATLGPPGParserHelper(List<Error> Errs, List<CompilerWarning> Warnings, string FileName)
        {
            this.Errs = Errs;
            this.Warnings = Warnings;
            this.FileName = FileName;
        }

        public syntax_tree_node Parse(string Text, List<compiler_directive> compilerDirectives = null)
        {
#if DEBUG
#if _ERR
            FileInfo f = new FileInfo(FileName);
            var sv = Path.ChangeExtension(FileName,".grmtrack1");
            var sw = new StreamWriter(sv);
            Console.SetError(sw);
#endif
#endif
            YATLParserTools parsertools = new YATLParserTools(); // контекст сканера и парсера
            parsertools.errors = Errs;
            parsertools.warnings = Warnings;
            parsertools.compilerDirectives = compilerDirectives;
            parsertools.CurrentFileName = Path.GetFullPath(FileName);


            var scanner = new Scanner();
            scanner.SetSource(Text, 0);
            scanner.parsertools = parsertools;// передали parsertools в объект сканера
            if (DefinesList != null)
                scanner.Defines.AddRange(DefinesList);
            YATLGPPGParser parser = new YATLGPPGParser(scanner);
            parsertools.build_tree_for_formatter = build_tree_for_formatter;
            parser.parsertools = parsertools; // передали parsertools в объект парсера

            if (!parser.Parse())
                if (Errs.Count == 0)
                    parsertools.AddError("Неопознанная синтаксическая ошибка!", null);
#if DEBUG
#if _ERR
            sw.Close();
#endif
#endif
            return parser.root;
        }
    }
    internal class YATLLanguageParser: BaseParser, IParser
    {
        private YATLGPPGParserHelper localparserhelper;
        //public Preprocessor2.Preprocessor2 preprocessor2 = new PascalABCCompiler.Preprocessor2.Preprocessor2(null);

        public YATLLanguageParser()
            : base("YATL", "0.0.1", "Copyright © 2023-2023 by Vladislav Krylov", new string[] { "PABCSystem", "PABCExtensions" }, false, new string[] { ".yatp" })
        {
        }

        public override void Reset()
        {
            CompilerDirectives = new List<compiler_directive>();
            Errors.Clear();
        }

        public override PascalABCCompiler.SourceFilesProviderDelegate SourceFilesProvider
        {
            get
            {
                return sourceFilesProvider;
            }
            set
            {
                sourceFilesProvider = value;
                //preprocessor2.SourceFilesProvider = value;
            }
        }

        public override void PreBuildTree(string FileName)
        {
            CompilerDirectives = new List<compiler_directive>();
            //preprocessor2 = new Preprocessor2.Preprocessor2(SourceFilesProvider);
        }

        public override PascalABCCompiler.SyntaxTree.syntax_tree_node BuildTree(string FileName, string Text, ParseMode ParseMode, List<string> DefinesList = null)
        {
            PreBuildTree(FileName);
            syntax_tree_node root = BuildTreeInNormalMode(FileName, Text, DefinesList);

            if (root != null && root is compilation_unit)
            {
                (root as compilation_unit).file_name = FileName;
                (root as compilation_unit).compiler_directives = CompilerDirectives;
                if (root is unit_module)
                    if ((root as unit_module).unit_name.HeaderKeyword == UnitHeaderKeyword.Library)
                        (root as compilation_unit).compiler_directives.Add(new compiler_directive(new token_info("apptype"), new token_info("dll")));
            }

            return root;
        }
        public override syntax_tree_node BuildTreeInNormalMode(string FileName, string Text, List<string> DefinesList = null)
        {
            Errors.Clear();
            Warnings.Clear();
            *//*string[] file_names = new string[1];
            file_names[0] = FileName;

            preprocessor2.Build(file_names, Errors, null);*//*

            localparserhelper = new YATLGPPGParserHelper(Errors, Warnings, FileName);
            localparserhelper.DefinesList = DefinesList;
            syntax_tree_node root = localparserhelper.Parse(Text);

            if (Errors.Count > 0)
                return null;

            if (root != null && root is compilation_unit)
                (root as compilation_unit).file_name = FileName;

            return root;
        }

    }
}
*/