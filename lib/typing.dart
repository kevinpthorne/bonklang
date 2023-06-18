abstract class BonkType {
  /// Size in bytes
  int get size;

  @override
  operator ==(other) => throw UnimplementedError("Type needs to implement ==");

  @override
  int get hashCode =>
      throw UnimplementedError("Type needs to implement hashCode");
}

abstract class TerminalType extends BonkType {
  final String name;

  TerminalType(this.name);

  @override
  operator ==(other) => other is TerminalType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class CharType extends TerminalType {
  CharType() : super("Char");

  @override
  int get size => 1;
}

class IntType extends TerminalType {
  IntType() : super("Int");

  @override
  int get size => 8;
}

class BoolType extends TerminalType {
  BoolType() : super("Bool");

  @override
  int get size => 1;
}

/// See UserTypeIdentifier token on definition (e.g. left side)
class AliasType extends TerminalType {
  final BonkType target;

  AliasType(String name, this.target) : super(name);

  @override
  int get size => target.size;
}

/// See UserTypeIdentifier token on declaration (e.g. right side)
class UserType extends TerminalType {
  UserType(String name) : super(name);

  @override
  int get size => throw UnsupportedError("UserTypes do not have size");
}

class GenericType<T extends BonkType> extends BonkType {
  final TerminalType generic;
  final T inner;

  GenericType(this.generic, this.inner);

  @override
  int get size => inner.size;

  @override
  operator ==(other) => other is GenericType && inner == other.inner;

  // @override
  // int get hashCode => super.hashCode;
}

class RefType extends GenericType<BonkType> {
  RefType(BonkType inner) : super(UserType('Ref'), inner);
}

class FunctionType extends BonkType {
  final ProductType inputs;
  final BonkType output;

  FunctionType(this.inputs, this.output);

  @override
  int get size => 8; // ptr
}

class SumType extends BonkType {
  final List<BonkType> options;

  SumType(this.options);

  /// SumType size is as big as its biggest option
  @override
  int get size => options
      .map((t) => t.size)
      .fold(-1, (prevSize, size) => prevSize > size ? prevSize : size);
}

class ProductType extends BonkType {
  final Map<String, BonkType> attributes;

  ProductType(this.attributes);

  /// ProductType size is a sum of all inner types
  @override
  int get size =>
      attributes.values.map((t) => t.size).fold(0, (sum, size) => sum + size);
}
