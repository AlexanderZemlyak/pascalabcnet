using System.Collections.Generic;
using Languages.Facade;
using PascalABCCompiler.SyntaxTreeConverters;
using PascalABCCompiler.SystemLibrary;
using PascalABCCompiler.TreeConverter;

namespace Languages.SLang
{
    public class SLangLanguage : BaseLanguage
    {
        public SLangLanguage() : base(
            name: "SLang",
            version: "0.0.1",
            copyright: "Copyright © 2024-2025 by Stanislav Leonchik",

            languageInformation: new Frontend.Data.SLangLanguageInformation(),
            parser: new SLangParser.SLangLanguageParser(),
            docParser: null,

            syntaxTreeConverters: new List<ISyntaxTreeConverter>() { new Frontend.Converters.StandardSyntaxTreeConverter(), new SyntaxSemanticVisitors.LambdaAnyConverter() },
            applySyntaxTreeConvertersForIntellisense: true,

            filesExtensions: new string[] { ".slang" },
            caseSensitive: false,
            systemUnitNames: new string[] { "SLangSystem", "SLangHidden", "LightPT", "PABCSystem" }
            )
        {
            ((SLangParser.SLangLanguageParser)Parser).SyntaxTreeConvertersForIntellisense = SyntaxTreeConverters;
        }

        public override void SetSemanticConstants()
        {
            SemanticRulesConstants.ClassBaseType = SystemLibrary.object_type;
            SemanticRulesConstants.StructBaseType = SystemLibrary.value_type;
            SemanticRulesConstants.AddResultVariable = true;
            SemanticRulesConstants.ZeroBasedStrings = true;
            SemanticRulesConstants.FastStrings = false;
            SemanticRulesConstants.InitStringAsEmptyString = true;
            SemanticRulesConstants.UseDivisionAssignmentOperatorsForIntegerTypes = false;
            SemanticRulesConstants.ManyVariablesOneInitializator = false;
            SemanticRulesConstants.OrderIndependedMethodNames = true;
            SemanticRulesConstants.OrderIndependedFunctionNames = false;
            SemanticRulesConstants.OrderIndependedTypeNames = false;
            SemanticRulesConstants.EnableExitProcedure = true;
            SemanticRulesConstants.StrongPointersTypeCheckForDotNet = true;
            SemanticRulesConstants.AllowChangeLoopVariable = false;
            SemanticRulesConstants.AllowGlobalVisibilityForPABCDll = true;
        }

        public override void SetSyntaxTreeToSemanticTreeConverter()
        {
            SyntaxTreeToSemanticTreeConverter = new SLangSyntaxTreeVisitor.slang_syntax_tree_visitor(LanguageProvider.Instance.MainLanguage.SyntaxTreeToSemanticTreeConverter);
        }

    }
}
