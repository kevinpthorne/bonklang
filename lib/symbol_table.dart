abstract class Registerable {
  int? _uid;

  int get uid => _uid ??= hashCode;
  set uid(int uid) => _uid = uid;
}