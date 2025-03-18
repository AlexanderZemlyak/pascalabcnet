using System.Collections.Generic;
using System.Linq;
using SLangParserYacc;

namespace SLangParser {
    public class SLangKeywords : PascalABCCompiler.Parsers.BaseKeywords {
        protected override Dictionary<string, int> KeywordsToTokens { get; set; }

        protected override string FileName => "keywordsmap.slang";

        public SLangKeywords() : base() {
            KeywordsToTokens = new Dictionary<string, int> {
                ["if"] = (int)Tokens.IF,
                ["elif"] = (int)Tokens.ELIF,
                ["else"] = (int)Tokens.ELSE,
                ["while"] = (int)Tokens.WHILE,
                ["for"] = (int)Tokens.FOR,
                ["in"] = (int)Tokens.IN,
                ["fn"] = (int)Tokens.FN,
                ["let"] = (int)Tokens.LET,
                ["return"] = (int)Tokens.RETURN,
                ["break"] = (int)Tokens.BREAK,
                ["continue"] = (int)Tokens.CONTINUE,
                ["and"] = (int)Tokens.AND,
                ["or"] = (int)Tokens.OR,
                ["not"] = (int)Tokens.NOT,
                ["use"] = (int)Tokens.USE,
                ["from"] = (int)Tokens.FROM,
                ["global"] = (int)Tokens.GLOBAL,
                ["true"] = (int)Tokens.TRUE,
                ["false"] = (int)Tokens.FALSE,
                ["mod"] = (int)Tokens.MOD,
                ["task"]    = (int)Tokens.TASK,
                ["input"]   = (int)Tokens.INPUT,
                ["solution"]= (int)Tokens.SOLUTION,
                ["tests"]   = (int)Tokens.TESTS,
                ["output"]  = (int)Tokens.OUTPUT,
            }
            .ToDictionary(kv => ConvertKeyword(kv.Key), kv => kv.Value);
        }

        protected override int GetIdToken() => (int)Tokens.ID;
    }

}
