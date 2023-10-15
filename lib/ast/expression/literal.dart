

import 'package:bonklang/ast/expression/generic.dart';
import 'package:bonklang/typing.dart';

abstract class PrimitiveLiteral<T> extends Expr {
  final T value;

  PrimitiveLiteral(super.ctx, this.value, [super.parent]);
}

// class NumLiteral extends PrimitiveLiteral<int> {
//   NumLiteral(super.ctx, super.value);

//   @override
//   BonkType get type => IntType();
// }

// class CharLiteral extends PrimitiveLiteral<String> {
//   CharLiteral(super.ctx, super.value) : assert(value.length == 1);

//   @override
//   BonkType get type => CharType();
// }

// class StrLiteral extends PrimitiveLiteral<String> {
//   StrLiteral(super.ctx, super.value);

//   @override
//   Type get type => StringType();
// }