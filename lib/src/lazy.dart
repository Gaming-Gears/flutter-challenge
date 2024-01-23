final class Lazy<T> {
  bool _initialized = false;
  late T _value;

  final T Function() initializer;

  Lazy(this.initializer) : super();

  T get value {
    if (_initialized) {
      return _value;
    } else {
      _value = initializer();
      _initialized = true;
      return _value;
    }
  }

  set value(T newValue) {
    _value = newValue;
    _initialized = true;
  }
}
