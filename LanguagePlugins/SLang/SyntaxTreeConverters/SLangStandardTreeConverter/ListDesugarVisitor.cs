/*using System.Collections.Generic;
using System.Data;
using PascalABCCompiler.SyntaxTree;
using SyntaxVisitors;

namespace Languages.SLang.Frontend.Converters
{
    internal class ListDesugarVisitor : BaseChangeVisitor
    {
        ParserLambdaHelper lambdaHelper = new ParserLambdaHelper();
        public ListDesugarVisitor() {  }

        public override void visit(generator_object _generator_object)
        {
            base.visit(_generator_object);

            dot_node dn;
            ident_list idList;
            formal_parameters formalPars;
            statement_list sl;
            function_lambda_definition lambda;
            method_call mc;

            // [ expr1 for ident in expr2 if expr3 ] -> expr2.Where(ident -> expr3).Select(ident -> expr1).ToList()
            if (_generator_object._condition != null)
            {
                string ident_name = _generator_object._ident.name;
                idList = new ident_list(new ident(ident_name), _generator_object._ident.source_context);
                formalPars = new formal_parameters(new typed_parameters(idList, new lambda_inferred_type(new lambda_any_type_node_syntax(), _generator_object._ident.source_context), parametr_kind.none, null, _generator_object._ident.source_context), _generator_object._ident.source_context);

                dn = new dot_node(_generator_object._range as addressed_value, (new ident("Where")) as addressed_value, _generator_object.source_context);

                sl = new statement_list(new assign("result", _generator_object._condition, _generator_object._condition.source_context), _generator_object._condition.source_context); //!
                sl.expr_lambda_body = true;
                lambda = new function_lambda_definition(
                lambdaHelper.CreateLambdaName(), formalPars,
                new lambda_inferred_type(new lambda_any_type_node_syntax(), _generator_object._ident.source_context), sl, _generator_object.source_context);

                mc = new method_call(dn as addressed_value, new expression_list(lambda as expression), _generator_object.source_context);
                dn = new dot_node(mc as addressed_value, (new ident("Select")) as addressed_value, _generator_object.source_context);
            }
            // [ expr1 for ident in expr2 ] -> expr2.Select(ident -> expr1).ToList()
            else
                dn = new dot_node(_generator_object._range as addressed_value, (new ident("Select")) as addressed_value, _generator_object.source_context);


            idList = new ident_list(_generator_object._ident, _generator_object._ident.source_context);
            formalPars = new formal_parameters(new typed_parameters(idList, new lambda_inferred_type(new lambda_any_type_node_syntax(), _generator_object._ident.source_context), parametr_kind.none, null, _generator_object._ident.source_context), _generator_object._ident.source_context);

            sl = new statement_list(new assign("result", _generator_object._expr, _generator_object._expr.source_context), _generator_object._expr.source_context);
            sl.expr_lambda_body = true;

            lambda = new function_lambda_definition(
                lambdaHelper.CreateLambdaName(), formalPars,
                new lambda_inferred_type(new lambda_any_type_node_syntax(), _generator_object._ident.source_context), sl, _generator_object.source_context);


            mc = new method_call(dn as addressed_value, new expression_list(lambda as expression), _generator_object.source_context);
            // dn = new dot_node(mc as addressed_value, (new ident("ToList")) as addressed_value, _generator_object.source_context);

            Replace(_generator_object, mc);
        }
    }

    public class ParserLambdaHelper
    {
        private int lambda_num = 0;
        public List<function_lambda_definition> lambdaDefinitions;
        public static string lambdaPrefix = "<>lambda";

        public ParserLambdaHelper()
        {
            lambdaDefinitions = new List<function_lambda_definition>();
        }

        public string CreateLambdaName()
        {
            lambda_num++;
            return lambdaPrefix + lambda_num.ToString();
        }

        public bool IsLambdaName(ident id)
        {
            return id.name.StartsWith(lambdaPrefix);
        }
    }
}
*/