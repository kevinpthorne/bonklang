import 'package:antlr4/antlr4.dart';
import 'package:bonklang/symbol_table.dart';
import 'package:bonklang/visitors/visitor.dart';

abstract class Node extends Registerable {
  Node? parent;
  ParserRuleContext ctx;

  Node(this.ctx, [this.parent]);

  accept(Visitor visitor);

  @override
  String toString() => '$runtimeType';
}
