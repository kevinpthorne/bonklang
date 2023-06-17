import 'package:bonklang/ast/module.dart';
import 'package:bonklang/ast/statement.dart';

abstract class Visitor<T> {

  /// Module

  T? preVisitModule(Module node) => null;
  T? visitModule(Module node, T? preResult, List<T> bodyResult);

  /// Statement

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
  T? visitMatch(Match node, T? preResult, T exprResult,
      /*Map<Expression, T?>*/ bodyResult);

  T? preVisitReturn(Return node) => null;
  T? visitReturn(Return node, T? preResult, T? exprResult);
}
