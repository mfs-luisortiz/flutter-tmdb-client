# kueski_app

A MovieDB app client.

## Dependencies

```
flutter pub add http sqflite bloc flutter_bloc provider
```

Test dependencies:

```
flutter pub add dev:mocktail
flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

Running Unit Tests:

```
flutter test test/unit_test.dart --dart-define=API_KEY=<key>
```

Running Integration Tests:

```
flutter test integration_test --dart-define=API_KEY=<key>
```

Execute:

```
flutter run --dart-define=API_KEY=<key>
```

## Workflow

1. First, based on the requirements I decided to design the main interfaces for
data sources and the related entities based on the json provided by MovieDB,
so I'm adding some unit tests to let me check the correctness before adding an
actual UI. Using Clean Architecture I'll focus in domain as a first step.

 - Define entities.
 - Define interfaces.
 - Define datasources' implementations and its dependencies.
 - Testing with mock dependecies of local storage and network calls
 - Define a strategy to secure API key and avoid to expose it in source code
