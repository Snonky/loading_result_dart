import '../result_dart.dart';

/// Adds methods for converting any object
/// into a `Result` type (`Success` or `Failure`).
extension ResultObjectExtension<W extends Object> on W {
  /// Convert the object to a `Result` type [Failure].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Failure<S, W> toFailure<S extends Object>() {
    assert(
      this is! ResultDart,
      'Don`t use the "toError()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toError()" method '
      'on instances of the Future.',
    );

    return Failure<S, W>(this);
  }

  /// Convert the object to a `Result` type [Success].
  ///
  /// Will throw an error if used on a `Result` or `Future` instance.
  Success<W, F> toSuccess<F extends Object>() {
    assert(
      this is! ResultDart,
      'Don`t use the "toSuccess()" method '
      'on instances of the Result.',
    );
    assert(
      this is! Future,
      'Don`t use the "toSuccess()" method '
      'on instances of the Future.',
    );
    return Success<W, F>(this);
  }
}

/// Extension on `Future<void>` to convert it into an `AsyncResultDart<Unit, Exception>`.
///
/// This extension provides a method `toAsyncResult` that wraps the completion
/// of a `Future<void>` into a `Success` or `Failure` object. If the `Future`
/// completes successfully, a `Success` containing `unit` is returned. If an
/// exception occurs, the exception is wrapped in a `Failure`.
///
/// Example usage:
/// ```dart
/// Future<void> future = Future.value();
/// AsyncResultDart<Unit, Exception> result = await future.toAsyncResult();
/// ```
extension FutureResultExtensionVoid on Future<void> {
  AsyncResultDart<Unit, Exception> toAsyncResult() async {
    try {
      await this;
      return Success(unit);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

/// Extension to flatten a nested [ResultDart] into a single [ResultDart].
///
/// Unwraps `ResultDart<ResultDart<S, F>, F>` into `ResultDart<S, F>`.
extension FlattenResultExtension<S extends Object, F extends Object>
    on ResultDart<ResultDart<S, F>, F> {
  /// Flattens a nested [ResultDart] by removing one level of nesting.
  ///
  /// If this is `Success(Success(value))`, returns `Success(value)`.
  /// If this is `Success(Failure(error))`, returns `Failure(error)`.
  /// If this is `Failure(error)`, returns `Failure(error)`.
  ResultDart<S, F> flatten() => fold((inner) => inner, Failure.new);
}

/// Extension to flatten a nested [AsyncResultDart] into a single
/// [AsyncResultDart].
///
/// Unwraps `AsyncResultDart<ResultDart<S, F>, F>` into
/// `AsyncResultDart<S, F>`.
extension FlattenAsyncResultExtension<S extends Object, F extends Object>
    on AsyncResultDart<ResultDart<S, F>, F> {
  /// Flattens a nested [AsyncResultDart] by removing one level of nesting.
  AsyncResultDart<S, F> flatten() {
    return then((result) => result.fold((inner) => inner, Failure.new));
  }
}
