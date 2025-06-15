using System.Collections.Generic;
using System.Data;
using System.Linq;
using PascalABCCompiler.SyntaxTree;
using SyntaxVisitors;

namespace Languages.SLang.Frontend.Converters
{
    internal class FunctionsWithNamedParametersDesugarVisitor : BaseChangeVisitor
    {
        public FunctionsWithNamedParametersDesugarVisitor() { }

        public override void visit(method_call _method_call)
        {
            if (_method_call.parameters is expression_list exprl) {
                expression_list args = new expression_list();
                expression_list kwargs = new expression_list();

                foreach (var expr in exprl.expressions)
                {
                    if (expr is name_assign_expr)
                    {
                        kwargs.Add(expr);
                        kwargs.source_context = new SourceContext(kwargs.source_context, expr.source_context);
                    }
                    else if (kwargs.expressions.Count() == 0)
                    {
                        args.Add(expr);
                        args.source_context = new SourceContext(args.source_context, expr.source_context);
                    }
                    else throw new SLangSyntaxVisitorError("ARG_AFTER_KWARGS", expr.source_context);
                }

                if (kwargs.expressions.Count() == 0)
                    Replace(_method_call, new method_call(_method_call.dereferencing_value, args, _method_call.source_context));
                else if (args.expressions.Count() == 0) 
                {
                    _method_call.parameters = kwargs;
                    return;
                }
                else
                {
                    method_call mc = new method_call(new ident("!" + ((_method_call.dereferencing_value as dot_node).right as ident).name + ".Get"), kwargs, _method_call.source_context);
                    dot_node dn = new dot_node(mc as addressed_value, (_method_call.dereferencing_value as dot_node).right, _method_call.source_context);
                    method_call to = new method_call(dn as addressed_value, args, _method_call.source_context);
                    Replace(_method_call, to);
                }
            }

            else
                Replace(_method_call, new method_call(_method_call.dereferencing_value as addressed_value, null, _method_call.source_context));
        }
    }
}
/*
namespace Languages.SLang.Frontend.Converters
   {
       internal class FunctionsWithNamedParametersDesugarVisitor : BaseChangeVisitor
       {
           public FunctionsWithNamedParametersDesugarVisitor() { }
   
           public override void visit(method_call _method_call)
           {
               if (_method_call.parameters is expression_list exprl) {
                   expression_list args = new expression_list();
                   expression_list kwargs_names_array = new expression_list();
                   expression_list kwargs = new expression_list();
   
                   foreach (var expr in exprl.expressions)
                   {
                       if (expr is name_assign_expr nae)
                       {
                           kwargs_names_array.Add(new string_const(nae.name.name));
                           kwargs_names_array.source_context
                               = new SourceContext(kwargs_names_array.source_context, expr.source_context);
                           kwargs.Add(nae.expr);
                           kwargs.source_context 
                               = new SourceContext(kwargs.source_context, expr.source_context);
                       }
                       else if (kwargs.expressions.Count() == 0)
                       {
                           args.Add(expr);
                           args.source_context = new SourceContext(args.source_context, expr.source_context);
                       }
                       else throw new SLangSyntaxVisitorError("ARG_AFTER_KWARGS", expr.source_context);
                   }
   
                   if (kwargs.expressions.Count() != 0)
                   {
                       array_const_new acn = new array_const_new(kwargs_names_array, '|');
                       kwargs.expressions.Insert(0, acn);
   
                       ident method_name = new ident();
                       if (_method_call.dereferencing_value is ident id)
                       {
                           method_name = id;
                       }
                       else if (_method_call.dereferencing_value is dot_node dnn)
                       {
                           method_name = dnn.right as ident;
                       }
   
                       ident class_name = new ident("!" + method_name);
                       new_expr ne = new new_expr(new named_type_reference(class_name), kwargs, false, null);
   
                       dot_node dn = new dot_node(ne, new ident(method_name.name), _method_call.source_context);
                       method_call new_method_call = new method_call(dn, args, _method_call.source_context);
                       Replace(_method_call, new_method_call);
                       return;
                   }
               }
               base.visit(_method_call);
           }
       }
   }
*/