sealed class Result<T, E> {
  const Result();

  bool get isErr => this is Err<T, E>;
  bool get isOk => this is Ok<T, E>;

  T unwrap() {
    return switch (this) {
      Ok(value: final val) => val,
      Err(error: final err) => throw StateError(
        'Called `unwrap()` -> Error Result: $err',
      ),
    };
  }

  E unwrapError() {
    return switch (this) {
      Err(error: final val) => val,
      Ok() => throw StateError('Called `unwrapError()` Ok Result'),
    };
  }
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
}

class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
}
