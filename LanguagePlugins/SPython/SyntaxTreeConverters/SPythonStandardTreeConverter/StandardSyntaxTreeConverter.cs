using PascalABCCompiler.SyntaxTree;
using PascalABCCompiler.SyntaxTreeConverters;

namespace Languages.SPython.Frontend.Converters
{
    public class StandardSyntaxTreeConverter : BaseSyntaxTreeConverter
    {
        public override string Name { get; } = "Standard";

        protected override syntax_tree_node ApplyConcreteConversions(syntax_tree_node root)
        {
            // замена узлов assign на узлы var внутри функций
            // основываясь на узлах global
            var sgsv = new SPythonGlobalStatementVisitor();
            sgsv.ProcessNode(root);

            // удаление узлов global
            var egnv = new EraseGlobalNodesVisitor();
            egnv.ProcessNode(root);

            // вынос переменных самого внешнего уровня на глобальный
            // если они используются в функциях (являются глобальными)
            var sfvugv = new SPythonRetainUsedGlobalVariablesVisitor();
            sfvugv.ProcessNode(root);

            return root;
        }
    }
}
