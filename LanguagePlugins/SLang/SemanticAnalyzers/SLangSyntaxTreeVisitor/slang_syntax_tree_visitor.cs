using System.Collections.Generic;
using PascalABCCompiler.SemanticTree;
using PascalABCCompiler.SyntaxTree;
using PascalABCCompiler.SystemLibrary;
using PascalABCCompiler.TreeConverter;
using PascalABCCompiler.TreeRealization;
using PascalABCCompiler.Errors;
using System.ComponentModel.Design;
using System;


namespace SLangSyntaxTreeVisitor
{
    // Возможно, стоит заменить на декоратор или стратегию вместо наследования EVA
    public class slang_syntax_tree_visitor : syntax_tree_visitor
    {
        syntax_tree_visitor mainVisitor;

        public slang_syntax_tree_visitor(syntax_tree_visitor mainSyntaxTreeVisitor) : base(false)
        {

            mainVisitor = mainSyntaxTreeVisitor;
            convertion_data_and_alghoritms = mainSyntaxTreeVisitor.convertion_data_and_alghoritms;
            ret = mainSyntaxTreeVisitor.ret;
            context = mainSyntaxTreeVisitor.context;
            contextChanger = mainSyntaxTreeVisitor.contextChanger;

            OnLeave = RunAdditionalChecks;
        }

        private void RunAdditionalChecks(syntax_tree_node node)
        {
            switch (node)
            {
                case bin_expr _bin_expr:
                    expression_node left = convert_strong(_bin_expr.left);
                    expression_node right = convert_strong(_bin_expr.right);
                    if (_bin_expr.operation_type == Operators.Plus)
                    {
                        if ((left.type.name == "string" && right.type.name == "integer") || (left.type.name == "integer" && right.type.name == "string"))
                        {
                            AddError(left.location, "SLANGSEMANTIC_NOT_ALLOWED_{0}_DIFF_TYPES_{1}_{2}", '+', left.type, right.type); ;
                            return;
                        }
                    }
                    break;
            }
            return;
        }

        protected override void get_system_module(common_unit_node psystem_unit)
        {
            init_system_module(psystem_unit);

            if (debugging)
            {
                List<SymbolInfo> si = SystemLibInitializer.CreateDiapason.SymbolInfo;
                si = SystemLibInitializer.CreateObjDiapason.SymbolInfo;
                si = SystemLibInitializer.TypedSetType.SymbolInfo;
            }

            CreateSpecialFields(psystem_unit);
        }

        // Инициализируем только переменные экземпляра, не влияем на глобальное состояние в отличие от визитора Паскаля EVA
        protected override void internal_reset()
        {
            _system_unit = mainVisitor._system_unit;
            SystemLibrary.system_unit = _system_unit;
            ResetSelfFields();
        }

        public override void AddError(location loc, string ErrResourceString, params object[] values)
        {
            Error err = new SLangSemanticError(loc, ErrResourceString, values);
            if (ErrResourceString == "FORWARD_DECLARATION_{0}_AS_BASE_TYPE")
            {
                throw err;
            }
            else
            {
                base.AddError(err);
            }
        }

        private type_node ConvertTypeNameToSLangTypeName(type_node tn)
        {
            string new_name = tn.PrintableName;
            new_name = new_name
                .Replace(",", ", ")
                .Replace("<", "[")
                .Replace(">", "]")
                .Replace("List", "list")
                .Replace("NewSet", "set")
                .Replace("Dictionary", "dict")
                .Replace("empty_list", "list[anytype]")
                .Replace("empty_set", "set[anytype]")
                .Replace("empty_dict", "dict[anytype]")
                .Replace("integer", "int")
                .Replace("string", "str")
                .Replace("real", "float")
                .Replace("boolean", "bool")
                .Replace("System.Numerics.BigInteger", "bigint");
            return new common_type_node(new_name, type_access_level.tal_public, null, null, tn.location);
        }

        public override void AddError(Error err, bool shouldReturn = false)
        {
            // TODO : Add Error Rerouting according to SLang semantics
            switch (err)
            {
                case OperatorCanNotBeAppliedToThisTypes _op_err:
                    if (_op_err.operator_name == "mod")
                        base.AddError(new OperatorCanNotBeAppliedToThisTypes("%", _op_err.left, _op_err.right, _op_err.loc), shouldReturn);
                    else if (_op_err.operator_name == "div")
                        base.AddError(new OperatorCanNotBeAppliedToThisTypes("//", _op_err.left, _op_err.right, _op_err.loc), shouldReturn);
                    return;
                case FunctionExpectedProcedureMeet _proc_meet:
                    base.AddError(new SLangSemanticError(_proc_meet.loc, "SLANGSEMANTIC_FUNCTION_{0}_NO_RETURN", _proc_meet.function.name));
                    return;
                case CanNotConvertTypes conv_err:
                    base.AddError(new CanNotConvertTypes(conv_err.expression_node,
                        ConvertTypeNameToSLangTypeName(conv_err.from), 
                        ConvertTypeNameToSLangTypeName(conv_err.to),
                        conv_err.loc));
                    return;
            }
            base.AddError(err, shouldReturn);

        }

        private Dictionary<string, Dictionary<string, string>> containersNamesMapping = new Dictionary<string, Dictionary<string, string>>
        {
            {"List",
                new Dictionary<string, string> {
                { "append", "Add" },
                { "clear", "Clear" },
                { "insert", "Insert" },
                { "remove", "Remove" },
                { "pop", "pop" },
                { "index", "IndexOf" },
                { "count", "!count" },
                { "sort", "Sort" },
                { "reverse", "Reverse" },
                { "copy", "ToList" },
                { "Select", "Select" },
                { "Where", "Where" },
            } },

            {"NewSet",
                new Dictionary<string, string> {
                { "add", "add" },
                { "remove", "remove" },
                { "copy", "copy" },
                { "Select", "Select" },
                { "Where", "Where" },
            } },

            {"Dictionary",
                new Dictionary<string, string> {
                { "keys", "get_keys" },
                { "values", "get_values" },
                { "copy", "copy" },
                { "Select", "Select" },
                { "Where", "Where" },
            } }
        };


        HashSet<method_call> visited_method_calls = new HashSet<method_call>();

        public override void visit(method_call _method_call)
        {
            if (visited_method_calls.Contains(_method_call))
            {
                base.visit(_method_call);
                return;
            }
            visited_method_calls.Add(_method_call);
            if (_method_call.dereferencing_value is dot_node dn && dn.right is ident id)
            {
                try
                {
                    expression_node left = convert_strong(dn.left);
                    //dn.left = new semantic_addr_value(left);
                    if (left?.type != null) 
                    foreach (string tName in containersNamesMapping.Keys)
                    {
                        if (left.type.name.StartsWith(tName))
                        {
                            if (!containersNamesMapping[tName].ContainsKey(id.name))
                            {
                                AddError(left.location, "SLANGSEMANTIC_TYPE_{0}_HAS_NO_{1}_METHOD", ConvertTypeNameToSLangTypeName(left.type), id.name);
                            }
                            else
                            {
                                id.name = containersNamesMapping[tName][id.name];
                            }
                        }
                    }
                }
                catch (Error e)
                {
                    if (e.Message != "Ожидалось имя переменной")
                        throw e; 
                }
            }
            base.visit(_method_call);
        }

        public override void visit(assign _assign)
        {

            if (_assign.from is bin_expr be && 
                _assign.to is ident il && 
                be.left is ident ir &&
                il.name == ir.name)
            {
                expression_node to = convert_strong(_assign.to);
                SourceContext sc = _assign.source_context;

                if (to.type.name.StartsWith("NewSet"))
                {
                    if (be.operation_type == Operators.LogicalAND)
                    {
                        var replace = new assign(new semantic_addr_value(to), be.right, Operators.AssignmentMultiplication, sc);
                        base.visit(replace);
                        return;
                    }
                    if (be.operation_type == Operators.LogicalOR)
                    {
                        var replace = new assign(new semantic_addr_value(to), be.right, Operators.AssignmentAddition, sc);
                        base.visit(replace);
                        return;
                    }
                }
            }
            base.visit(_assign);
        }

        public override void visit(bin_expr _bin_expr) {
            expression_node left = convert_strong(_bin_expr.left);
            expression_node right = convert_strong(_bin_expr.right);

            var new_bin_expr = new bin_expr(new semantic_addr_value(left), new semantic_addr_value(right),
                _bin_expr.operation_type, _bin_expr.source_context);

            RunAdditionalChecks(new_bin_expr);

            switch (_bin_expr.operation_type) {
                case Operators.LogicalOR:
                    if (left.type.name.StartsWith("NewSet") && left.type.name == right.type.name) {
                        new_bin_expr.operation_type = Operators.Plus;
                    }

                    break;
                case Operators.LogicalAND:
                    if (left.type.name.StartsWith("NewSet") && left.type.name == right.type.name) {
                        new_bin_expr.operation_type = Operators.Multiplication;
                    }

                    break;
                case Operators.Division:
                    if (left.type == right.type && left.type.name == "string") {
                        var mcn = new method_call(
                            new dot_node(new semantic_addr_value(left, left.location), new ident("IndexOf")),
                            new expression_list(new semantic_addr_value(right, right.location)),
                            _bin_expr.source_context);
                        visit(mcn);
                        return;
                    }

                    break;
                case Operators.IntegerDivision:
                    if (left.type == right.type && left.type.name == "real") {
                        var exprlist = new expression_list();
                        exprlist.source_context = _bin_expr.source_context;
                        exprlist.Add(new semantic_addr_value(left, left.location));
                        exprlist.Add(new semantic_addr_value(right, right.location));
                        var floornode = new method_call(new ident("!FloorDiv"), exprlist, _bin_expr.source_context);
                        visit(floornode);
                        return;
                    }

                    break;
                case Operators.ModulusRemainder:
                    if (left.type == right.type && left.type.name == "real") {
                        var exprlist = new expression_list();
                        exprlist.source_context = _bin_expr.source_context;
                        exprlist.Add(new semantic_addr_value(left, left.location));
                        exprlist.Add(new semantic_addr_value(right, right.location));
                        var modnode = new method_call(new ident("!FloorMod"), exprlist, _bin_expr.source_context);
                        visit(modnode);
                        return;
                    }

                    break;
            }

            base.visit(new_bin_expr);
        }
    }
}
