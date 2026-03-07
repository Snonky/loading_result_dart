import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

void main() {
  group('flatMap', () {
    test('async ', () async {
      final result = await const Success(1) //
          .toAsyncResult()
          .flatMap((success) async => Success(success * 2));
      expect(result.getOrNull(), 2);
    });

    test('sink', () async {
      final result = await const Success(1) //
          .toAsyncResult()
          .flatMap((success) => Success(success * 2));
      expect(result.getOrNull(), 2);
    });
  });

  group('flatMapError', () {
    test('async ', () async {
      final result = await const Failure(1) //
          .toAsyncResult()
          .flatMapError((error) async => Failure(error * 2));
      expect(result.exceptionOrNull(), 2);
    });

    test('sink', () async {
      final result = await const Failure(1) //
          .toAsyncResult()
          .flatMapError((error) => Failure(error * 2));
      expect(result.exceptionOrNull(), 2);
    });
  });

  test('map', () async {
    final result = await const Success(1) //
        .toAsyncResult()
        .map((success) => success * 2);

    expect(result.getOrNull(), 2);
    expect(const Failure(2).toAsyncResult().map(identity), completes);
  });

  test('mapError', () async {
    final result = await const Failure(1) //
        .toAsyncResult()
        .mapError((error) => error * 2);
    expect(result.exceptionOrNull(), 2);
    expect(const Success(2).toAsyncResult().mapError(identity), completes);
  });

  test('pure', () async {
    final result = await const Success(1).toAsyncResult().pure(10);

    expect(result.getOrNull(), 10);
  });
  test('pureError', () async {
    final result = await const Failure(1).toAsyncResult().pureError(10);

    expect(result.exceptionOrNull(), 10);
  });

  group('swap', () {
    test('Success to Error', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.exceptionOrNull(), 0);
    });

    test('Error to Success', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final swap = await result.swap();

      expect(swap.getOrNull(), 0);
    });
  });

  group('fold', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();
      final futureValue = result.fold(id, (e) => -1);
      expect(futureValue, completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();
      final futureValue = result.fold(identity, (e) => e);
      expect(futureValue, completion(0));
    });
  });

  group('tryGetSuccess and tryGetError', () {
    test('Success', () async {
      final result = const Success<int, String>(0).toAsyncResult();

      expect(result.isSuccess(), completion(true));
      expect(result.getOrNull(), completion(0));
    });

    test('Error', () async {
      final result = const Failure<String, int>(0).toAsyncResult();

      expect(result.isError(), completion(true));
      expect(result.exceptionOrNull(), completion(0));
    });
  });

  group('getOrThrow', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<String, int>(0).toAsyncResult();
      expect(result.getOrThrow(), throwsA(0));
    });
  });

  group('getOrElse', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      final value = result.getOrElse((f) => -1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int, int>(0).toAsyncResult();
      final value = result.getOrElse((f) => 2);
      expect(value, completion(2));
    });
  });

  group('getOrDefault', () {
    test('Success', () {
      final result = const Success<int, String>(0).toAsyncResult();
      final value = result.getOrDefault(-1);
      expect(value, completion(0));
    });

    test('Error', () {
      final result = const Failure<int, int>(0).toAsyncResult();
      final value = result.getOrDefault(2);
      expect(value, completion(2));
    });
  });

  group('recover', () {
    test('Success', () {
      final result = const Success<int, String>(0) //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(0));
    });

    test('Error', () {
      final result = const Failure<int, String>('failure') //
          .toAsyncResult()
          .recover((f) => const Success(1));
      expect(result.getOrThrow(), completion(1));
    });
  });

  group('onSuccess', () {
    test('Success', () {
      const Success<int, String>(0) //
          .toAsyncResult()
          .onFailure((failure) {})
          .onSuccess(
        expectAsync1(
          (value) {
            expect(value, 0);
          },
        ),
      );
    });

    test('Error', () {
      const Failure<int, String>('failure') //
          .toAsyncResult()
          .onSuccess((success) {})
          .onFailure(
        expectAsync1(
          (value) {
            expect(value, 'failure');
          },
        ),
      );
    });
  });

  group('tap', () {
    test('Success', () async {
      ResultDart<int, String>? captured;
      final result = await const Success<int, String>(0) //
          .toAsyncResult()
          .tap((r) => captured = r);

      expect(result.getOrNull(), 0);
      expect(captured, isA<Success<int, String>>());
    });

    test('Failure', () async {
      ResultDart<int, String>? captured;
      final result = await const Failure<int, String>('err') //
          .toAsyncResult()
          .tap((r) => captured = r);

      expect(result.exceptionOrNull(), 'err');
      expect(captured, isA<Failure<int, String>>());
    });
  });

  group('filter', () {
    test('Success passes test', () async {
      final result = await const Success<int, String>(4) //
          .toAsyncResult()
          .filter((s) => s > 0, (s) => 'not positive');

      expect(result.getOrNull(), 4);
    });

    test('Success fails test', () async {
      final result = await const Success<int, String>(-1) //
          .toAsyncResult()
          .filter((s) => s > 0, (s) => 'not positive');

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), 'not positive');
    });

    test('Failure passthrough', () async {
      final result = await const Failure<int, String>('err') //
          .toAsyncResult()
          .filter((s) => s > 0, (s) => 'not positive');

      expect(result.exceptionOrNull(), 'err');
    });
  });

  group('zip', () {
    test('Success + Success', () async {
      final result = await const Success<int, String>(1) //
          .toAsyncResult()
          .zip(const Success<String, String>('a'));

      expect(result.getOrNull(), (1, 'a'));
    });

    test('Success + Failure', () async {
      final result = await const Success<int, String>(1) //
          .toAsyncResult()
          .zip(const Failure<String, String>('err'));

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), 'err');
    });

    test('Failure + Success', () async {
      final result = await const Failure<int, String>('err') //
          .toAsyncResult()
          .zip(const Success<String, String>('a'));

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), 'err');
    });
  });

  group('flatten', () {
    test('Success(Success)', () async {
      final result = await Future.value(
        const Success<ResultDart<int, String>, String>(Success(42)),
      ).flatten();

      expect(result.getOrNull(), 42);
    });

    test('Success(Failure)', () async {
      final result = await Future.value(
        const Success<ResultDart<int, String>, String>(Failure('inner')),
      ).flatten();

      expect(result.exceptionOrNull(), 'inner');
    });

    test('Failure', () async {
      final result = await Future.value(
        const Failure<ResultDart<int, String>, String>('outer'),
      ).flatten();

      expect(result.exceptionOrNull(), 'outer');
    });
  });

  group('recoverWhen', () {
    test('Success passthrough', () async {
      final result = await const Success<int, String>(0) //
          .toAsyncResult()
          .recoverWhen(
            (f) => true,
            (f) => const Success(99),
          );
      expect(result.getOrThrow(), 0);
    });

    test('Failure with matching predicate', () async {
      final result = await const Failure<int, String>('recoverable') //
          .toAsyncResult()
          .recoverWhen(
            (f) => f == 'recoverable',
            (f) => const Success(99),
          );
      expect(result.getOrThrow(), 99);
    });

    test('Failure with non-matching predicate', () async {
      final result = await const Failure<int, String>('critical') //
          .toAsyncResult()
          .recoverWhen(
            (f) => f == 'recoverable',
            (f) => const Success(99),
          );
      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), 'critical');
    });

    test('Failure with async recovery', () async {
      final result = await const Failure<int, String>('recoverable') //
          .toAsyncResult()
          .recoverWhen(
            (f) => f == 'recoverable',
            (f) async => const Success(99),
          );
      expect(result.getOrThrow(), 99);
    });
  });
}
