import 'dart:collection';

import 'package:bonklang/ast/generic.dart';
import 'package:bonklang/typing.dart';
import 'package:bonklang/visitors/visitor.dart';

abstract class Statement extends Node {
  Statement(ctx, Node parent) : super(ctx, parent);
}

class Import extends Statement {
  final String alias;
  final String path;

  Import(super.ctx, this.alias, this.path, super.parent);

  @override
  accept(Visitor visitor) =>
      visitor.visitImport(this, visitor.preVisitImport(this));
}

class TypeDeclaration extends Statement {
  final String name;
  final Type type;

  TypeDeclaration(super.ctx, this.name, this.type, super.parent);

  @override
  accept(Visitor visitor) =>
      visitor.visitTypeDeclaration(this, visitor.preVisitTypeDeclaration(this));
}

class FunctionDeclaration extends Statement {
  final String name;
  final FunctionType type;
  final List<Statement> body;

  FunctionDeclaration(super.ctx, this.name, this.type, this.body, super.parent);

  @override
  accept(Visitor visitor) {
    final pre = visitor.preVisitFunctionDeclaration(this);
    final bodyResult = body.map((s) => s.accept(visitor)).toList();
    return visitor.visitFunctionDeclaration(this, pre, bodyResult);
  }
}

class Assignment extends Statement {
  final /*Lvalue*/ left;
  final /*Expression*/ right;

  Assignment(super.ctx, this.left, this.right, super.parent);

  @override
  accept(Visitor visitor) => visitor.visitAssignment(
      this,
      visitor.preVisitAssignment(this),
      left.accept(visitor),
      right.accept(visitor));
}

class ExpressionStatement extends Statement {
  final /*Expression*/ expression;

  ExpressionStatement(super.ctx, this.expression, super.parent);

  @override
  accept(Visitor visitor) {
    return visitor.visitExpressionStatement(
      this,
      visitor.preVisitExpressionStatement(this),
      expression.accept(visitor),
    );
  }
}

class While extends Statement {
  final /*Expression*/ expression;
  final List<Statement> body;

  While(super.ctx, this.expression, this.body, super.parent);

  @override
  accept(Visitor visitor) {
    final pre = visitor.preVisitWhile(this);
    final bodyResult = body.map((s) => s.accept(visitor)).toList();
    return visitor.visitWhile(
        this, pre, expression.accept(visitor), bodyResult);
  }
}

class If extends Statement {
  final /*Expression*/ expression;
  final List<Statement> body;
  final Else? else_;

  If(super.ctx, this.expression, this.body, this.else_, super.parent);

  @override
  accept(Visitor visitor) {
    final pre = visitor.preVisitIf(this);
    final bodyResult = body.map((s) => s.accept(visitor)).toList();
    return visitor.visitIf(this, pre, expression.accept(visitor), bodyResult,
        else_?.accept(visitor));
  }
}

class Else extends Statement {
  final List<Statement> body;

  Else(super.ctx, this.body, super.parent);

  @override
  accept(Visitor visitor) {
    final pre = visitor.preVisitElse(this);
    final bodyResult = body.map((s) => s.accept(visitor)).toList();
    return visitor.visitElse(this, pre, bodyResult);
  }
}

class Break extends Statement {
  Break(super.ctx, super.parent);

  @override
  accept(Visitor visitor) =>
      visitor.visitBreak(this, visitor.preVisitBreak(this));
}

class Continue extends Statement {
  Continue(super.ctx, super.parent);

  @override
  accept(Visitor visitor) =>
      visitor.visitContinue(this, visitor.preVisitContinue(this));
}

class Match extends Statement {
  final /*Expression*/ expression;
  final /*Map<Expression, List<Statement>>*/ body;

  Match(super.ctx, this.expression, this.body, super.parent);

  @override
  accept(Visitor visitor) {
    var /*Map<Expression, dynamic>*/ bodyResult = LinkedHashMap();

    var preResult = visitor.preVisitMatch(this);
    var expResult = expression.accept(visitor);
    for (var entry in body.entries) {
      bodyResult[entry.key] = entry.value.accept(visitor);
    }

    return visitor.visitMatch(this, preResult, expResult, bodyResult);
  }
}

class Return extends Statement {
  final /*Expression?*/ expression;

  Return(super.ctx, this.expression, super.parent);

  @override
  accept(Visitor visitor) =>
      visitor.visitReturn(this, visitor.preVisitReturn(this), expression.accept(visitor));
}
