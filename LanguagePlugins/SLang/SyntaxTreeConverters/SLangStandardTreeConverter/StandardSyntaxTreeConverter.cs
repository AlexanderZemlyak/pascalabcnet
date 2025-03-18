using PascalABCCompiler;
using PascalABCCompiler.SyntaxTree;
using PascalABCCompiler.SyntaxTreeConverters;

namespace Languages.SLang.Frontend.Converters {
    public class StandardSyntaxTreeConverter : BaseSyntaxTreeConverter {
        public override string Name { get; } = "Standard";

        protected override syntax_tree_node ApplyConversions(syntax_tree_node root) {
            return root;
        }

        public override syntax_tree_node ConvertAfterUsedModulesCompilation(syntax_tree_node root,
            in CompilationArtifactsUsedBySyntaxConverters compilationArtifacts) {
            return root;
        }
    }
}