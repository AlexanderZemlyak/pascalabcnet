using PascalABCCompiler.Errors;
using PascalABCCompiler.SyntaxTree;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Languages.SLang.Frontend.Converters
{
    public static class SLangStringResources
    {
        public static string Get(string key)
        {
            return PascalABCCompiler.StringResources.Get("SLANGSYNTAXTREEVISITORSERROR_" + key);
        }

        public static string Get(string key, params object[] values)
        {
            return (string.Format(Get(key), values));
        }
    }

    public class SLangSyntaxVisitorError : SyntaxError
    {
        public SLangSyntaxVisitorError(string resourcestring, SourceContext sc, params object[] values) : base(SLangStringResources.Get(resourcestring, values), "", sc, null)
        {

        }
        public SLangSyntaxVisitorError(string resourcestring, PascalABCCompiler.SyntaxTree.syntax_tree_node bad_node)
            : base(SLangStringResources.Get(resourcestring), "", bad_node.source_context, bad_node)
        {

        }
    }
}
