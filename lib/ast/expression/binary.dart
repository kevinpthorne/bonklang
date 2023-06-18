import 'package:bonklang/ast/expression/generic.dart';
import 'package:bonklang/visitors/visitor.dart';

class ExpExpr extends ArthimeticBinaryExpr {
  ExpExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitExpExpr(
      this,
      visitor.preVisitExpExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class MultiplyExpr extends ArthimeticBinaryExpr {
  MultiplyExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitMultiplyExpr(
      this,
      visitor.preVisitMultiplyExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class DivideExpr extends ArthimeticBinaryExpr {
  DivideExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitDivideExpr(
      this,
      visitor.preVisitDivideExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class AddExpr extends ArthimeticBinaryExpr {
  AddExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitAddExpr(
      this,
      visitor.preVisitAddExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class SubtractExpr extends ArthimeticBinaryExpr {
  SubtractExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitSubtractExpr(
      this,
      visitor.preVisitSubtractExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class LEExpr extends BooleanBinaryExpr {
  LEExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitLEExpr(
      this,
      visitor.preVisitLEExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class LEQExpr extends BooleanBinaryExpr {
  LEQExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitLEQExpr(
      this,
      visitor.preVisitLEQExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class GEExpr extends BooleanBinaryExpr {
  GEExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitGEExpr(
      this,
      visitor.preVisitGEExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class GEQExpr extends BooleanBinaryExpr {
  GEQExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitGEQExpr(
      this,
      visitor.preVisitGEQExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class EquivExpr extends BooleanBinaryExpr {
  EquivExpr(super.ctx, super.right, super.left, [super.parent]);
  
  @override
  accept(Visitor visitor) => visitor.visitEquivExpr(
      this,
      visitor.preVisitEquivExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class XORExpr extends BooleanBinaryExpr {
  XORExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitXORExpr(
      this,
      visitor.preVisitXORExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class ANDExpr extends BooleanBinaryExpr {
  ANDExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitANDExpr(
      this,
      visitor.preVisitANDExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}

class ORExpr extends BooleanBinaryExpr {
  ORExpr(super.ctx, super.right, super.left, [super.parent]);

  @override
  accept(Visitor visitor) => visitor.visitORExpr(
      this,
      visitor.preVisitORExpr(this),
      left.accept(visitor),
      right.accept(visitor));
}
