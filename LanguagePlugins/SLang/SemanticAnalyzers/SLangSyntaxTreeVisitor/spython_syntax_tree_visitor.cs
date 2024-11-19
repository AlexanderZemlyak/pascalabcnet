using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PascalABCCompiler.SemanticTree;
using PascalABCCompiler.SyntaxTree;
using PascalABCCompiler.SystemLibrary;
using PascalABCCompiler.TreeConverter.TreeConversion;
using PascalABCCompiler.TreeConverter;
using PascalABCCompiler.TreeRealization;
using PascalABCCompiler.Errors;


namespace SLangSyntaxTreeVisitor
{
    public class spython_syntax_tree_visitor : syntax_tree_visitor
    {
        public spython_syntax_tree_visitor(): base()
        {
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
                            //base.AddError(left.location, "SLANGSEMANTIC_NOT_ALLOWED_{0}_DIFF_TYPES_{1}_{2}", Operators.Plus, left.type, right.type); ;
                            return;
                        }
                    }
                    break;
            }
            return;
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
        public override void AddError(Error err, bool shouldReturn = false)
        {
            // TODO : Add Error Rerouting according to SLang semantics
            switch (err)
            {
                case OperatorCanNotBeAppliedToThisTypes _op_err:
                    if (_op_err.operator_name == "mod")
                    {
                        base.AddError(new OperatorCanNotBeAppliedToThisTypes("%", _op_err.left, _op_err.right, _op_err.loc), shouldReturn);
                        return;
                    }
                    else if (_op_err.operator_name == "div")
                    {
                        base.AddError(new OperatorCanNotBeAppliedToThisTypes("//", _op_err.left, _op_err.right, _op_err.loc), shouldReturn);
                        return;
                    }
                    break;
                case FunctionExpectedProcedureMeet _proc_meet:
                    base.AddError(new SLangSemanticError(_proc_meet.loc, "SLANGSEMANTIC_FUNCTION_{0}_NO_RETURN", _proc_meet.function.name));
                    return;
                case SimpleSemanticError _ss_err:
                    break;
            }
            base.AddError(err, shouldReturn);

        }
        public override void visit(bin_expr _bin_expr)
        {
            expression_node left = convert_strong(_bin_expr.left);
            expression_node right = convert_strong(_bin_expr.right);

            var new_bin_expr = new bin_expr(new semantic_addr_value(left), new semantic_addr_value(right), _bin_expr.operation_type, _bin_expr.source_context);

            RunAdditionalChecks(new_bin_expr);

            switch (_bin_expr.operation_type)
            {
                /*case Operators.Plus:
                    if (left.type == right.type && left.type.name == "boolean")
                    {
                        var int_left = new method_call(new ident("int"), new expression_list(new semantic_addr_value(left, left.location)), left.location);
                        var int_right = new method_call(new ident("int"), new expression_list(new semantic_addr_value(right, right.location)), right.location);
                        var bti_bin_expr = new bin_expr(int_left, int_right, _bin_expr.operation_type, _bin_expr.source_context);
                        visit(bti_bin_expr);
                        return;
                    }
                    break;*/
                case Operators.Division:
                    if (left.type == right.type && left.type.name == "string")
                    {
                        var mcn = new method_call(new dot_node(new semantic_addr_value(left, left.location), new ident("IndexOf")),
                            new expression_list(new semantic_addr_value(right, right.location)), _bin_expr.source_context);
                        visit(mcn);
                        return; 
                    }
                    break;
                case Operators.IntegerDivision:
                    if (left.type == right.type && left.type.name == "real")
                    {
                        var exprlist = new expression_list(); exprlist.source_context = _bin_expr.source_context;
                        exprlist.Add(new semantic_addr_value(left, left.location));
                        exprlist.Add(new semantic_addr_value(right, right.location));
                        var floornode = new method_call(new ident("!FloorDiv"), exprlist, _bin_expr.source_context);
                        visit(floornode);
                        return;
                    }
                    break;
                case Operators.ModulusRemainder:
                    if (left.type == right.type && left.type.name == "real")
                    {
                        //var divnode = new bin_expr(new semantic_addr_value(left, left.location), new semantic_addr_value(right, right.location), Operators.IntegerDivision, _bin_expr.source_context);
                        //var multnode = new bin_expr(new semantic_addr_value(right, right.location), divnode, Operators.Multiplication);
                        //var modnode = new bin_expr(new semantic_addr_value(left, left.location), multnode, Operators.Minus);
                        var exprlist = new expression_list(); exprlist.source_context = _bin_expr.source_context;
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
