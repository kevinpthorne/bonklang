import 'package:bonklang/ast/expression/generic.dart';
import 'package:bonklang/typing.dart';
import 'package:bonklang/visitors/visitor.dart';

class NumNegateExpr extends UnaryExpr {
  NumNegateExpr(super.ctx, super.right, [super.parent]);

  @override
  BonkType get type {
    assert(right.type is IntType);
    return IntType();
  }

  @override
  accept(Visitor visitor) => visitor.visitNumNegateExpr(
      this, visitor.preVisitNumNegateExpr(this), right.accept(visitor));
}

class BooleanNotExpr extends UnaryExpr {
  BooleanNotExpr(super.ctx, super.right, [super.parent]);

  @override
  BonkType get type {
    assert(right.type is BoolType);
    return BoolType();
  }

  @override
  accept(Visitor visitor) => visitor.visitBooleanNotExpr(
      this, visitor.preVisitBooleanNotExpr(this), right.accept(visitor));
}

class DerefExpr extends UnaryExpr {
  DerefExpr(super.ctx, super.right, [super.parent]);

  @override
  BonkType get type => right.type;

  @override
  accept(Visitor visitor) => visitor.visitDerefExpr(
      this, visitor.preVisitDerefExpr(this), right.accept(visitor));
}

class RefExpr extends UnaryExpr {
  RefExpr(super.ctx, super.right, [super.parent]);

  @override
  BonkType get type => RefType(right.type);

  @override
  accept(Visitor visitor) => visitor.visitRefExpr(
      this, visitor.preVisitRefExpr(this), right.accept(visitor));
}
