// import 'package:bonklang/bonklang.dart' as bonklang;
import 'package:antlr4/antlr4.dart';
import 'package:bonklang/antlr/BonkLexer.dart';
import 'package:bonklang/antlr/BonkParser.dart';

void main(List<String> arguments) async {
  // print('Hello world: ${bonklang.calculate()}!');

  BonkLexer.checkVersion();
  BonkParser.checkVersion();
  final input = await InputStream.fromPath("example.bonk");
  final lexer = BonkLexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = BonkParser(tokens);
  parser.addErrorListener(DiagnosticErrorListener());
  parser.buildParseTree = true;
  final tree = parser.module();
}
