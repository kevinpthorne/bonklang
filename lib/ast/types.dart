import 'package:bonklang/ast/generic.dart';

abstract class BonkType extends Node {
  int get size;

  BonkType(super.ctx, [super.parent]);

  @override
  operator ==(other) => throw UnimplementedError("Type needs to implement ==");

  @override
  int get hashCode =>
      throw UnimplementedError("Type needs to implement hashCode");
}


abstract class TerminalType extends BonkType {
  final String name;

  TerminalType(super.ctx, this.name, [super.parent]);

  @override
  operator ==(other) => other is TerminalType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// class CharType extends TerminalType {
//   CharType(super.ctx, [super.name = "Char", super.parent]);

//   @override
//   int get size => 1;
// }