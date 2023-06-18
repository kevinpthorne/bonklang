import 'dart:ffi';

import 'package:bonklang/ast/expression/binary.dart';
import 'package:bonklang/ast/expression/unary.dart';
import 'package:bonklang/ast/module.dart';
import 'package:bonklang/ast/statement.dart';

abstract class Visitor<T> {
  // Module

  T? preVisitModule(Module node) => null;
  T? visitModule(Module node, T? preResult, List<T> bodyResult);

  // Statement

  T? preVisitImport(Import node) => null;
  T? visitImport(Import node, T? preResult);

  T? preVisitTypeDeclaration(TypeDeclaration node) => null;
  T? visitTypeDeclaration(TypeDeclaration node, T? preResult);

  T? preVisitFunctionDeclaration(FunctionDeclaration node) => null;
  T? visitFunctionDeclaration(
      FunctionDeclaration node, T? preResult, List<T> bodyResult);

  T? preVisitAssignment(Assignment node) => null;
  T? visitAssignment(
      Assignment node, T? preResult, T leftResult, T rightResult);

  T? preVisitExpressionStatement(ExpressionStatement node) => null;
  T? visitExpressionStatement(
      ExpressionStatement node, T? preResult, T exprResult);

  T? preVisitWhile(While node) => null;
  T? visitWhile(While node, T? preResult, T exprResult, List<T> bodyResult);

  T? preVisitIf(If node) => null;
  T? visitIf(
      If node, T? preResult, T exprResult, List<T> bodyResult, T? elseResult);

  T? preVisitElse(Else node) => null;
  T? visitElse(Else node, T? preResult, List<T> bodyResult);

  T? preVisitBreak(Break node) => null;
  T? visitBreak(Break node, T? preResult);

  T? preVisitContinue(Continue node) => null;
  T? visitContinue(Continue node, T? preResult);

  T? preVisitMatch(Match node) => null;
  T? visitMatch(Match node, T? preResult, T exprResult, List<T> bodyResult);

  T? preVisitPatternCase(PatternCase node) => null;
  T? visitPatternCase(
      PatternCase node, T? preResult, T exprResult, List<T> bodyResult);

  T? preVisitReturn(Return node) => null;
  T? visitReturn(Return node, T? preResult, T? exprResult);

  // Expressions

  /// Expressions: Unary

  T? preVisitNumNegateExpr(NumNegateExpr node) => null;
  T? visitNumNegateExpr(NumNegateExpr node, T? preResult, T exprResult);

  T? preVisitBooleanNotExpr(BooleanNotExpr node) => null;
  T? visitBooleanNotExpr(BooleanNotExpr node, T? preResult, T exprResult);

  T? preVisitDerefExpr(DerefExpr node) => null;
  T? visitDerefExpr(DerefExpr node, T? preResult, T exprResult);

  T? preVisitRefExpr(RefExpr node) => null;
  T? visitRefExpr(RefExpr node, T? preResult, T exprResult);

  /// Expressions: Binary

  T? preVisitExpExpr(ExpExpr node) => null;
  T? visitExpExpr(ExpExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitMultiplyExpr(MultiplyExpr node) => null;
  T? visitMultiplyExpr(MultiplyExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitDivideExpr(DivideExpr node) => null;
  T? visitDivideExpr(DivideExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitAddExpr(AddExpr node) => null;
  T? visitAddExpr(AddExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitSubtractExpr(SubtractExpr node) => null;
  T? visitSubtractExpr(SubtractExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitLEExpr(LEExpr node) => null;
  T? visitLEExpr(LEExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitLEQExpr(LEQExpr node) => null;
  T? visitLEQExpr(LEQExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitGEExpr(GEExpr node) => null;
  T? visitGEExpr(GEExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitGEQExpr(GEQExpr node) => null;
  T? visitGEQExpr(GEQExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitEquivExpr(EquivExpr node) => null;
  T? visitEquivExpr(EquivExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitXORExpr(XORExpr node) => null;
  T? visitXORExpr(XORExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitANDExpr(ANDExpr node) => null;
  T? visitANDExpr(ANDExpr node, T? preResult, T leftResult, T rightResult);

  T? preVisitORExpr(ORExpr node) => null;
  T? visitORExpr(ORExpr node, T? preResult, T leftResult, T rightResult);
}
