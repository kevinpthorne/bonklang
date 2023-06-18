import 'package:bonklang/ast/generic.dart';
import 'package:bonklang/typing.dart';

abstract class Expr extends Node {
  Expr(super.ctx, [super.parent]);

  BonkType get type;
}

abstract class UnaryExpr<R extends Expr> extends Expr {
  final R right;

  UnaryExpr(super.ctx, this.right, [super.parent]);
}

abstract class BinaryExpr<L extends Expr, R extends Expr> extends UnaryExpr<R> {
  final L left;

  BinaryExpr(super.ctx, super.right, this.left, [super.parent]);
}

abstract class ArthimeticBinaryExpr<L extends Expr, R extends Expr>
    extends BinaryExpr<L, R> {
  ArthimeticBinaryExpr(super.ctx, super.right, super.left, [super.parent])
      : assert(right.type is IntType || left.type is IntType);

  @override
  BonkType get type => IntType();
}

abstract class BooleanBinaryExpr<L extends Expr, R extends Expr>
    extends BinaryExpr<L, R> {
  BooleanBinaryExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  BonkType get type => BoolType();
}
