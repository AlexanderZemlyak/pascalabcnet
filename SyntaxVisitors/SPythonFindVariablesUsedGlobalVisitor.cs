using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using PascalABCCompiler;
using PascalABCCompiler.SyntaxTree;

namespace SyntaxVisitors
{
    public class SPythonFindVariablesUsedGlobalVisitor : WalkingVisitorNew
    {
        public HashSet<string> VariablesDeclaredGlobal { get; set; }
        public HashSet<string> VariablesUsedGlobal { get; set; }
        private HashSet<string> LocalVariables { get; set; }
        private bool isInFunctionBody { get; set; }

        public SPythonFindVariablesUsedGlobalVisitor() 
        {
            VariablesDeclaredGlobal = new HashSet<string>();
            VariablesUsedGlobal = new HashSet<string>();
            LocalVariables = new HashSet<string>();

            isInFunctionBody = false;

            OnEnter = OnEnterAction;
            OnLeave = OnLeaveAction;
        }

        private void Clear()
        {
            LocalVariables = new HashSet<string>();
        }

        private void OnEnterAction(syntax_tree_node stn)
        {
            if (stn is procedure_definition _procedure_definition)
            {
                isInFunctionBody = true;
            }
        }

        private void OnLeaveAction(syntax_tree_node stn)
        {
            if (stn is procedure_definition _procedure_definition)
            {
                isInFunctionBody = false;
                Clear();
            }
        }

        public override void visit(variable_definitions _variable_definitions)
        {
            VariablesDeclaredGlobal.Add(_variable_definitions.var_definitions[0].vars.idents[0].name);

            base.visit(_variable_definitions);
        }

        public override void visit(var_statement _var_statement)
        {
            if (isInFunctionBody)
                foreach (ident id in _var_statement.var_def.vars.idents)
                    LocalVariables.Add(id.name);

            base.visit(_var_statement);
        }

        public override void visit(typed_parameters _typed_parameters)
        {
            LocalVariables.Add(_typed_parameters.idents.idents[0].name);

            base.visit(_typed_parameters);
        }

        public override void visit(assign _assign)
        {
            if (isInFunctionBody &&
                _assign.to is ident _ident && 
                VariablesDeclaredGlobal.Contains(_ident.name) &&
                !LocalVariables.Contains(_ident.name)
                && !VariablesUsedGlobal.Contains(_ident.name) // для дебага
                )
                VariablesUsedGlobal.Add(_ident.name);

            base.visit(_assign);
        }

        public override void visit(ident _ident)
        {
            if (isInFunctionBody &&
                VariablesDeclaredGlobal.Contains(_ident.name) &&
                !LocalVariables.Contains(_ident.name)
                && !VariablesUsedGlobal.Contains(_ident.name) // для дебага
                )
                VariablesUsedGlobal.Add(_ident.name);

            base.visit(_ident);
        }
    }
}
