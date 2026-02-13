# WorkOn Flutter Testing Guide

## Overview

WorkOn uses Flutter's built-in testing framework for unit tests and widget tests.

## Current Test Coverage

### Test Files

| Category | File | Description |
|----------|------|-------------|
| **Services** | `test/services/earnings_models_test.dart` | Earnings data models |
| **Services** | `test/services/message_models_test.dart` | Message data models |
| **Services** | `test/services/mission_models_test.dart` | Mission data models |
| **Widgets** | `test/widgets/auth_test.dart` | Authentication screens |
| **Widgets** | `test/widgets/chat_test.dart` | Chat functionality |
| **Widgets** | `test/widgets/drawer_test.dart` | Navigation drawer |
| **Widgets** | `test/widgets/earnings_test.dart` | Earnings display |
| **Widgets** | `test/widgets/home_test.dart` | Home screen |
| **Widgets** | `test/widgets/jobs_test.dart` | Jobs list |
| **Widgets** | `test/widgets/missions_map_test.dart` | Map view |
| **Widgets** | `test/widgets/profile_test.dart` | Profile screen |
| **Core** | `test/widget_test.dart` | Core UI components |

### Coverage Baseline (January 2026)

- **Tests**: 108 passing
- **Model Coverage**: ~89% (earnings, messages, missions models)
- **Widget Tests**: Functional but use mocks (lower code coverage impact)

## Running Tests

### All Tests
```bash
flutter test
```

### With Coverage
```bash
flutter test --coverage
```

Coverage report generated at `coverage/lcov.info`

### Single Test File
```bash
flutter test test/widgets/auth_test.dart
```

### Verbose Output
```bash
flutter test --reporter expanded
```

## Coverage Trajectory

### Phase 1 - Baseline (Current)
- ✅ 108 widget/model tests
- ✅ Core UI components tested
- ✅ CI pipeline with coverage reporting

### Phase 2 - Services (Target: +15%)
- [ ] `AuthService` unit tests
- [ ] `MissionsApiService` unit tests
- [ ] `UserService` unit tests
- [ ] `StripeService` integration tests (mocked)

### Phase 3 - Critical Flows (Target: +15%)
- [ ] Login/Signup flow end-to-end
- [ ] Mission booking flow
- [ ] Payment flow (mocked Stripe)

### Phase 4 - Edge Cases (Target: +10%)
- [ ] Error handling scenarios
- [ ] Network failure recovery
- [ ] Offline mode behavior

## Test Helpers

### Mock HTTP Client
Located at `test/services/mock_http_client.dart`

```dart
import 'package:work_on_v1/test/services/mock_http_client.dart';

final mockClient = MockHttpClient();
mockClient.mockGet('/api/missions', {'data': [...]});
```

### Test Helpers
Located at `test/helpers/test_helpers.dart`

Provides:
- Widget pump utilities
- Common test fixtures
- Mock providers

## CI Integration

GitHub Actions workflow at `.github/workflows/ci.yml`:

1. **Analyze** - Static analysis
2. **Test** - Unit/widget tests with coverage
3. **Build** - Android build verification

Coverage is uploaded to Codecov for tracking.

## Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyService', () {
    late MyService service;

    setUp(() {
      service = MyService();
    });

    test('should do something', () {
      final result = service.doSomething();
      expect(result, isNotNull);
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyWidget(),
      ),
    );

    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

## Best Practices

1. **No network calls in tests** - Use mocks
2. **No flaky tests** - Avoid timing-dependent assertions
3. **Descriptive names** - `should_return_error_when_network_fails`
4. **Isolated tests** - Each test should be independent
5. **Fast tests** - Target < 100ms per test

