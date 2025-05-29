using System.Collections.Generic;
using System.Data;
using System.Linq;
using PascalABCCompiler.SyntaxTree;
using SyntaxVisitors;

namespace Languages.SLang.Frontend.Converters
{
    internal class FlattenTaskSectionsVisitor : BaseChangeVisitor
    {
        private void Flatten(statement sectionNode, statement_list innerStmts)
        {
            var list = sectionNode.Parent as statement_list;
            if (list == null) return;

            innerStmts.subnodes.Reverse();

            foreach (var st in innerStmts.subnodes)
                list.InsertAfter(sectionNode, st.TypedClone());

            ReplaceStatement(sectionNode, new empty_statement());
        }

        public override void visit(input_section   node) => Flatten(node, node.stmts);
        public override void visit(check_section   node) => Flatten(node, node.stmts);
        public override void visit(tests_section   node) => Flatten(node, node.stmts);
        public override void visit(output_section  node) => Flatten(node, node.stmts);
    }

}