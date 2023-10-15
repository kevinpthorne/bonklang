abstract class BonkType {
  /// Stack size in bytes
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

// TODO register this as primitive type in symbol table
class CharType extends TerminalType {
  CharType() : super("Char");

  @override
  int get size => 1;
}

// TODO register this as primitive type in symbol table
class IntType extends TerminalType {
  IntType() : super("Int");

  @override
  int get size => 8;
}

// TODO register this as primitive type in symbol table
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
  final int _size;

  UserType(super.name, this._size);

  @override
  int get size => _size;
}

// class StrType extends UserType {
//   StrType([int length = 1]) : super(s);

// }

class GenericType extends BonkType {
  final BonkType generic;
  final BonkType inner;

  GenericType(this.generic, this.inner);

  @override
  int get size => generic.size + inner.size;

  @override
  operator ==(other) => other is GenericType && inner == other.inner;

  // @override
  // int get hashCode => super.hashCode;
}

// TODO register this as primitive type in symbol table
class RefType extends GenericType {
  RefType(BonkType inner) : super(UserType('Ref', 0), inner);
}

class ArrayType extends GenericType {
  ArrayType(BonkType inner, [int length = 1])
      : super(
            ProductType({
              "length": IntType(),
              "location": IntType(),
              "refOf": FunctionType(
                ProductType({"offset": IntType()}),
                RefType(inner),
              ),
              "value": FunctionType(
                ProductType({"offset": IntType()}),
                inner
              ),
            }),
            inner);
}

class StrType extends ArrayType {
  StrType([int length = 0]) : super(CharType(), length + 1);
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
