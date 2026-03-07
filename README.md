<a name="readme-top"></a>


<h1 align="center">RESULT_DART</h1>

<!-- PROJECT LOGO -->
<br />
<!-- <div align="center">
  <a href="https://github.com/Flutterando/README-Template/">
    <img src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/logo.png" alt="Logo" width="180">
  </a> -->

  <p align="center">
    This package aims to create an implemetation of <b>Kotlin's and Swift's Result class and own operators</b>.
    Inspired by `multiple_result` package, the `dartz` package and the `fpdart` package.  
    <br />
    <!-- Put the link for the documentation here -->
    <a href="https://pub.dev/documentation/result_dart/latest/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <!-- Disable unused links with with comments -->
    <a href="https://github.com/Flutterando/result_dart/issues">Report Bug</a>
    ·
    <a href="https://github.com/Flutterando/result_dart/pulls">Request Feature</a>
  </p>

<br>

<div align='center'>

[![Version](https://img.shields.io/github/v/release/Flutterando/result_dart?style=plastic)](https://pub.dev/packages/result_dart)
[![Pub Points](https://img.shields.io/pub/points/result_dart?label=pub%20points&style=plastic)](https://pub.dev/packages/result_dart/score)
[![Flutterando Analysis](https://img.shields.io/badge/style-flutterando__analysis-blueviolet?style=plastic)](https://pub.dev/packages/flutterando_analysis/)

[![Pub Publisher](https://img.shields.io/pub/publisher/result_dart?style=plastic)](https://pub.dev/publishers/flutterando.com.br/packages)


</div>

<br>

---
<!-- TABLE OF CONTENTS -->
<!-- Linked to every ## title below -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#how-to-use">How to Use</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

---

<br>

<!-- ABOUT THE PROJECT -->
## About The Project


<!-- PROJECT EXAMPLE (IMAGE) -->

<br>
<!-- <Center>
<img src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/project-image.png" alt="Project Screenshot" width="400">
</Center> -->

<br>

<!-- PROJECT DESCRIPTION -->

Overruns are common in design, and modern architectures always designate a place to handle failures.
This means dramatically decreasing try/catch usage and keeping treatments in one place.
But the other layers of code need to know about the two main values `[Success, Failure]`. The solution lies in the
`Result` class pattern implemented in `Kotlin` and `Swift` and now also in `Dart` via this package(`result_dart`).

<i>This project is distributed under the MIT License. See `LICENSE` for more information.
</i>

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Migrate 1.1.1 to 2.0.0

This version aims to reduce the `Result` boilerplate by making the `Failure` type Exception by default. This will free the Result from having to type `Failure`, making the declaration smaller.

```dart
// Old
Result<int, Exception> myResult = Success(42);

// NEW
Result<int> myResult = Success(42);

```

if there is a need to type it, use `ResultDart<Success, Failure>`:

```dart
// Old
Result<int, String> myResult = Success(42);

// NEW
ResultDart<int, String> myResult = Success(42);

```


<!-- GETTING STARTED -->
## Getting Started

<!---- The description provided below was aimed to show how to install a pub.dev package, change it as you see fit for your project ---->
To get `result_dart` working in your project follow either of the instructions below:

a) Add `result_dart` as a dependency in your Pubspec.yaml:
 ```yaml
   dependencies:
     result_dart: x.x.x
``` 

b) Use Dart Pub:
```
  dart pub add result_dart
```

<br>


## How to Use


In the return of a function that you want to receive an answer as Sucess or Failure, set it to return a Result type;

```dart
Result getSomethingPretty();
```

then add the Success and the Failure types.

```dart
Result<String> getSomethingPretty() {

}

```

In the return of the above function, you just need to use:
```dart
// Using Normal instance
return Success('Something Pretty');

// import 'package:result_dart/functions.dart'
return successOf('Something Pretty');

// Using extensions
return 'Something Pretty'.toSuccess();
```

or

```dart
// Using Normal instance
return Failure(Exception('something ugly happened...'));

// import 'package:result_dart/functions.dart'
return failureOf('Something Pretty');

// Using extensions
return 'something ugly happened...'.toFailure();
```

The function should look something like this:

```dart

Result<String> getSomethingPretty() {
    if(isOk) {
        return Success('OK!');
    } else {
        return Failure(Exception('Not Ok!'));
    }
}

```
or when using extensions, like this:

```dart

Result<String> getSomethingPretty() {
    if(isOk) {
        return 'OK!'.toSuccess();
    } else {
        return Exception('Not Ok!').toFailure();
    }
}

```

> IMPORTANT NOTE: The `toSuccess()` and `toFailure()` methods cannot be used on a `Result` object or a `Future`. If you try, will be throw a Assertion exception.

<br>

#### Handling the Result with `fold`:

Returns the result of onSuccess for the encapsulated value
if this instance represents `Success` or the result of onError function
for the encapsulated value if it is `Failure`.

```dart
void main() {
    final result = getSomethingPretty();
     final String message = result.fold(
        (success) {
          // handle the success here
          return "success";
        },
         (failure) {
          // handle the failure here
          return "failure";
        },
    );

}
```

#### Handling the Result with `getOrThrow`

Returns the success value as a throwing expression.

```dart
void main() {
    final result = getSomethingPretty();

    try {
     final value = result.getOrThrow();
    } on Exception catch(e){
      // e
    }
}

```

#### Handling the Result with `getOrNull`

Returns the value of [Success] or null.

```dart
void main() {
    final result = getSomethingPretty();
    result.getOrNull();
}

```

#### Handling the Result with `getOrElse`

Returns the encapsulated value if this instance represents `Success`
or the result of `onFailure` function for
the encapsulated a `Failure` value.

```dart
void main() {
    final result = getSomethingPretty();
    result.getOrElse((failure) => 'OK');
}

```

#### Handling the Result with `getOrDefault`

Returns the encapsulated value if this instance represents
`Success` or the `defaultValue` if it is `Failure`.

```dart
void main() {
    final result = getSomethingPretty();
    result.getOrDefault('OK');
}

```


#### Handling the Result with `exceptionOrNull`

Returns the value of [Failure] or null.

```dart
void main() {
    final result = getSomethingPretty();
    result.exceptionOrNull();
}
```

### Transforming a Result

#### Mapping success value with `map`

Returns a new `Result`, mapping any `Success` value
using the given transformation.

```dart
void main() {
    final result = getResult()
        .map((e) => MyObject.fromMap(e));

    result.getOrNull(); //Instance of 'MyObject' 
}
```

#### Mapping failure value with `mapError`

Returns a new `Result`, mapping any `Error` value
using the given transformation.

```dart
void main() {
    final result = getResult()
        .mapError((e) => MyException(e));

    result.exceptionOrNull(); //Instance of 'MyException'

}
```

#### Chain others [Result] by any `Success` value with `flatMap`


Returns a new `Result`, mapping any `Success` value
using the given transformation and unwrapping the produced `Result`.

```dart

Result<String, MyException> checkIsEven(String input){
    if(input % 2 == 0){
        return Success(input);
    } else {
        return Failure(MyException('isn`t even!'));
    }
}

void main() {
    final result = getNumberResult()
        .flatMap((s) => checkIsEven(s));
}
```
#### Chain others [Result] by `Failure` value with `flatMapError`


Returns a new `Result`, mapping any `Error` value
using the given transformation and unwrapping the produced `Result`.

```dart

void main() {
    final result = getNumberResult()
        .flatMapError((e) => checkError(e));
}
```

#### Resolve [Result] by `Failure` value with `recover`

Returns the encapsulated `Result` of the given transform function
applied to the encapsulated a `Failure` or the original
encapsulated value if it is success.

```dart

void main() {
    final result = getNumberResult()
        .recover((f) => Success('Resolved!'));
}
```

#### Conditionally resolve [Result] by `Failure` value with `recoverWhen`

Returns the encapsulated `Result` of the given transform function
applied to the encapsulated a `Failure` **only if the test predicate returns `true`**.
Otherwise, returns the original `Failure` unchanged.
If this is a `Success`, returns it unchanged.

```dart
void main() {
    final result = getNumberResult()
        .recoverWhen(
          (f) => f is TimeoutException,
          (f) => Success('Recovered from timeout!'),
        );
    // Only recovers TimeoutException, other failures propagate unchanged
}
```

#### Inspect a [Result] with `tap`

Performs the given action on the `Result` regardless of whether it
is a `Success` or `Failure`. Returns the original `Result` unchanged.
Useful for debugging and logging intermediate states in a chain.

```dart
void main() {
    final result = getNumberResult()
        .tap((r) => print('Step 1: $r'))
        .flatMap((s) => validateNumber(s))
        .tap((r) => print('Step 2: $r'));
}
```

#### Filter a `Success` value with `filter`

Returns this `Result` if it is a `Failure` or if the predicate
returns `true` for the encapsulated `Success` value.
Otherwise, returns a `Failure` created by `orElse`.

```dart
void main() {
    final result = getNumberResult()
        .filter(
          (n) => n > 0,
          (n) => Exception('$n is not positive'),
        );
}
```

#### Combine two [Result]s with `zip`

Combines this `Result` with another into a single `Result`
containing a `Record` of both success values.
If either is a `Failure`, returns the first `Failure` encountered.

```dart
void main() {
    final name = Success<String, Exception>('Jacob');
    final age = Success<int, Exception>(25);

    final combined = name.zip(age);
    // Success(('Jacob', 25))

    combined.map((record) {
      final (n, a) = record;
      return 'Name: $n, Age: $a';
    });
}
```

#### Flatten a nested [Result] with `flatten`

Unwraps a `ResultDart<ResultDart<S, F>, F>` into a `ResultDart<S, F>`,
removing one level of nesting.

```dart
void main() {
    final nested = Success<ResultDart<int, String>, String>(Success(42));
    final flat = nested.flatten();
    // Success(42)
}
```

#### Add a pure `Success` value with `pure`

Change the [Success] value.

```dart
void main() {
    final result = getSomethingPretty().pure(10);

    String? mySuccessResult;
    if (result.isSuccess()) {
      mySuccessResult = result.getOrNull(); // 10
    }
}
```

#### Add a pure `Failure` value with `pureError`

Change the [Failure] value.

```dart
void main() {
    final result = getSomethingPretty().pureError(10);
    if (result.isFailure()) {
       result.exceptionOrNull(); // 10
    }
}
```
#### Swap a `Result` with `swap`

Swap the values contained inside the [Success] and [Failure]
of this [Result].

```dart
void main() {
    Result<String, int> result =...;
    Result<int, String> newResult = result.swap();
}
```

### Unit Type

Some results do not need a specific return. Use the Unit type to signal an **empty** return.

```dart
    Result<Unit>
```

### Help with functions that return their parameter:

NOTE: use import 'package:result_dart/functions.dart'


Sometimes it is necessary to return the parameter of the function as in this example:

```dart
final result = Success(0);

String value = result.when((s) => '$s', (e) => e);
print(string) // "0";
```

We can use the `identity` function or its acronym `id` to facilitate the declaration of this type of function that returns its own parameter and does nothing else:

```dart
final result = Success(0);

// changed `(e) => e` by `id`
String value = result.when((s) => '$s', id);
print(string) // "0";
```

### Use **AsyncResult** type:

`AsyncResult<S, E>` represents an asynchronous computation.
Use this component when working with asynchronous **Result**.

**AsyncResult** has some of the operators of the **Result** object to perform data transformations (**Success** or **Failure**) before executing the Future.

All **Result** operators is available in **AsyncResult**

`AsyncResult<S, E>` is a **typedef** of `Future<Result<S, E>>`.

```dart

AsyncResult<String> fetchProducts() async {
    try {
      final response = await dio.get('/products');
      final products = ProductModel.fromList(response.data);
      return Success(products);
    } on DioError catch (e) {
      return Failure(ProductException(e.message));
    }
}

...

final state = await fetch()
    .map((products) => LoadedState(products))
    .mapLeft((failure) => ErrorState(failure))

```
<br>

<!-- _For more examples, please refer to the_ [Documentation]()  -->

<!---- You can use the emoji 🚧 to indicate Work In Progress sections ---->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FEATURES -->

<!---- Marcar com ✅ o que foi feito
e 🚧 para o que está sendo trabalhado ---->
## Features

- ✅ Result implementation.
- ✅ Result`s operators(map, flatMap, mapError, flatMapError, swap, when, fold, getOrNull, exceptionOrNull, isSuccess, isError).
- ✅ AsyncResult implementation.
- ✅ AsyncResult`s operators(map, flatMap, mapError, flatMapError, swap, when, fold, getOrNull, exceptionOrNull, isSuccess, isError).
- ✅ Auxiliar functions (id, identity, success, failure).
- ✅ Unit type.
- ✅ `tap` operator for debugging and logging.
- ✅ `filter` operator for conditional Success-to-Failure conversion.
- ✅ `zip` operator for combining two Results using Dart 3 Records.
- ✅ `flatten` operator for unwrapping nested Results.
- ✅ `recoverWhen` operator for conditional recovery by predicate.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Best Practices

### Scoped Recovery

When chaining many operations with `recover`, errors from earlier steps may be accidentally recovered. To avoid this, group related operations into their own functions:

```dart
// ❌ Avoid: recover may catch unrelated errors
fetchUser()
  .flatMap(fetchOrders)
  .flatMap(validateOrders)
  .recover(fallbackOrders)  // may recover a fetchUser error!
  .flatMap(processOrders);

// ✅ Prefer: scope the recovery to the relevant operations
AsyncResult<Orders> getValidOrders() {
  return fetchUser()
    .flatMap(fetchOrders)
    .flatMap(validateOrders)
    .recover(fallbackOrders); // only recovers validation/fetch errors
}

getValidOrders()
  .flatMap(processOrders);
```

Alternatively, use `recoverWhen` to recover only specific error types:

```dart
fetchUser()
  .flatMap(fetchOrders)
  .flatMap(validateOrders)
  .recoverWhen(
    (f) => f is ValidationException,
    (f) => fallbackOrders(),
  )
  .flatMap(processOrders);
```

### Custom Exceptions with StackTrace

The `Failure` type is a generic container and does not capture stack traces.
If you need stack traces for debugging, capture them in your custom Exception classes:

```dart
class AppException implements Exception {
  final String message;
  final StackTrace stackTrace;

  AppException(this.message) : stackTrace = StackTrace.current;

  @override
  String toString() => 'AppException: $message\n$stackTrace';
}
```

This way, the stack trace travels with the error through the Result chain,
and `tap` can be used to inspect it:

```dart
fetchData()
  .tap((r) => print(r))  // prints "Failure(AppException: ...)" with stack
  .flatMap(process);
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the appropriate tag. 
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Remember to include a tag, and to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and [Semantic Versioning](https://semver.org/) when uploading your commit and/or creating the issue. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

<!---- Those are the current Flutterando contacts as of 25 August 2022 --->
## Contact

Flutterando Community
- [Discord](https://discord.flutterando.com.br/)
- [Telegram](https://t.me/flutterando)
- [Website](https://www.flutterando.com.br)
- [Youtube Channel](https://www.youtube.com.br/flutterando)
- [Other useful links](https://linktr.ee/flutterando)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements 


Thank you to all the people who contributed to this project, whithout you this project would not be here today.

<br>

<!---- Change the link below to the contributors page of your project and change the repo= in the img src to properly point to your repository -->

<a href="https://github.com/flutterando/result_dart/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterando/result_dart" />
</a>


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MANTAINED BY -->
## Maintaned by

<br>
<p align="center">
  <a href="https://www.flutterando.com.br">
    <img width="110px" src="https://raw.githubusercontent.com/Flutterando/README-Template/master/readme_assets/logo-flutterando.png">
  </a>
  <p align="center">
    Built and maintained by <a href="https://www.flutterando.com.br">Flutterando</a>.
  </p>
</p>
