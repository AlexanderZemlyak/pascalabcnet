using PascalABCCompiler.SyntaxTree;

namespace Languages.SLang.Frontend.Converters
{
    public class TypeCorrectVisitor : BaseChangeVisitor
    {

        private bool forIntellisense;

        public TypeCorrectVisitor(bool forIntellisense)
        {
            this.forIntellisense = forIntellisense;
        }

        public override void visit(named_type_reference _named_type_reference)
        {
            ident id = _named_type_reference.names[_named_type_reference.names.Count - 1];
            
            if (!forIntellisense)
            {
                switch (id.name)
                {
                    case "int":
                        id.name = "integer";
                        break;
                    case "float":
                        id.name = "real";
                        break;
                    case "str":
                        id.name = "string";
                        break;
                    case "bool":
                        id.name = "boolean";
                        break;
                    case "bigint":
                        id.name = "biginteger";
                        break;

                    case "integer":
                        throw new SLangSyntaxVisitorError("PASCALABCNET_TYPE_{0}_INSTEAD_OF_SLANG_TYPE_{1}",
                       id.source_context, id.name, "int");
                    case "real":
                        throw new SLangSyntaxVisitorError("PASCALABCNET_TYPE_{0}_INSTEAD_OF_SLANG_TYPE_{1}",
                       id.source_context, id.name, "float");
                    case "string":
                        throw new SLangSyntaxVisitorError("PASCALABCNET_TYPE_{0}_INSTEAD_OF_SLANG_TYPE_{1}",
                       id.source_context, id.name, "str");
                    case "boolean":
                        throw new SLangSyntaxVisitorError("PASCALABCNET_TYPE_{0}_INSTEAD_OF_SLANG_TYPE_{1}",
                       id.source_context, id.name, "bool");
                    case "biginteger":
                        throw new SLangSyntaxVisitorError("PASCALABCNET_TYPE_{0}_INSTEAD_OF_SLANG_TYPE_{1}",
                       id.source_context, id.name, "bigint");
                }
            }

            switch (id.name)
            {
                case "list":
                    id.name = "!list";
                    break;
                case "dict":
                    id.name = "!dict";
                    break;
                case "set":
                    id.name = "!set";
                    break;
            }
        }
    }
}
