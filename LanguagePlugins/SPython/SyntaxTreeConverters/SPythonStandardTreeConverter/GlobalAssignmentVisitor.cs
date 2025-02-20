using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.AccessControl;
using System.Xml.Linq;
using System.Xml.Serialization;
using PascalABCCompiler.SyntaxTree;
using SyntaxVisitors;


namespace Languages.SPython.Frontend.Converters
{
    public class GlobalAssignmentVisitor : BaseChangeVisitor
    {
        private HashSet<string> globalVariables = new HashSet<string>();
        private HashSet<string> visitedVariables = new HashSet<string>();

        private Dictionary<string, var_def_statement> variablesToDefinitions = new Dictionary<string, var_def_statement>();

        public GlobalAssignmentVisitor() { }

        // нужны методы из BaseChangeVisitor, но порядок обхода из WalkingVisitorNew
        public override void DefaultVisit(syntax_tree_node n)
        {
            if (n == null) return;
            for (var i = 0; i < n.subnodes_count; i++)
                ProcessNode(n[i]);
        }

        public override void visit(procedure_definition _procedure_definition)
        {
            // do nothing...
        }

        public override void visit(var_def_statement _var_def_statement)
        {
            string variable_name = _var_def_statement.vars.idents[0].name;
            globalVariables.Add(variable_name);
            variablesToDefinitions[variable_name] = _var_def_statement;
        }

        private bool NeedTypeHint(string name, expression initial_value)
        {
            if (!(variablesToDefinitions[name].vars_type is same_type_node))
                return false;
            if (initial_value is dot_node)
                return true;
            if (initial_value is ident _ident && !globalVariables.Contains(_ident.name))
                return true;
            return false;
        }

        public override void visit(assign _assign)
        {
            if (_assign.to is ident _ident && !visitedVariables.Contains(_ident.name))
            {
                // first assignment of this global variable
                visitedVariables.Add(_ident.name);
                if (NeedTypeHint(_ident.name, _assign.from))
                {
                    variablesToDefinitions[_ident.name].vars_type = null;
                    variablesToDefinitions[_ident.name].inital_value = _assign.from;
                }
            }
        }
    }
}
