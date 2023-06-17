import 'package:bonklang/ast/generic.dart';
import 'package:bonklang/ast/statement.dart';
import 'package:bonklang/visitors/visitor.dart';

class Module extends Node {
  final List<Statement> body;

  Module(super.ctx, this.body);

  @override
  accept(Visitor visitor) {
    final pre = visitor.preVisitModule(this);
    final bodyResult = body.map((s) => s.accept(visitor)).toList();
    return visitor.visitModule(this, pre, bodyResult);
  }
}
