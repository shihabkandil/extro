# Feature Flag Service

## Overview

The Feature Flag Service provides a flexible way to control the visibility and behavior of features in the application. It's designed with future extensibility in mind, allowing for remote configuration while currently operating with local, in-memory storage. The service follows clean architecture principles and integrates with the project's Cubit state management pattern.

## Architecture

The feature flag system consists of:

1. **`FeatureFlag` enum** - Type-safe feature flag identifiers
2. **`IFeatureFlagService` interface** - Contract for feature flag operations (domain layer)
3. **`FeatureFlagService` implementation** - Local in-memory implementation (data layer)
4. **`FeatureFlagCubit`** - Cubit for managing feature flags in presentation layer
5. **`FeatureFlagState`** - Freezed state for the cubit
6. **Context extension** - Convenient access via BuildContext

## Usage

### Setup

First, wrap your app with `BlocProvider` for the `FeatureFlagCubit`:

```dart
import 'package:extro/core/feature_flags/cubit/feature_flag_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureFlagCubit(),
      child: MaterialApp(
        // ... your app
      ),
    );
  }
}
```

### Basic Usage in Widgets

#### Check if a feature is enabled:

```dart
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/feature_flag_extensions.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.isFeatureEnabled(FeatureFlag.dashboard)) {
      return DashboardScreen();
    } else {
      return ComingSoonScreen();
    }
  }
}
```

#### Conditional rendering:

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Welcome'),
      if (context.isFeatureEnabled(FeatureFlag.oauthProviders))
        GoogleSignInButton(),
      if (context.isFeatureEnabled(FeatureFlag.exampleFeature))
        ExampleFeatureWidget(),
    ],
  );
}
```

### Usage in Cubits (Domain Layer)

For domain layer (cubits, repositories), inject the service via constructor:

```dart
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';

class MyCubit extends Cubit<MyState> {
  final IFeatureFlagService _featureFlagService;

  MyCubit({IFeatureFlagService? featureFlagService})
      : _featureFlagService = featureFlagService ?? locator<IFeatureFlagService>(),
        super(MyState.initial());

  void doSomething() {
    if (_featureFlagService.isEnabled(FeatureFlag.exampleFeature)) {
      // Execute feature logic
    }
  }
}
```

### Programmatic Control

#### In presentation layer (using FeatureFlagCubit):

```dart
final cubit = context.read<FeatureFlagCubit>();

// Enable a feature
cubit.enable(FeatureFlag.dashboard);

// Disable a feature
cubit.disable(FeatureFlag.exampleFeature);

// Update multiple flags
cubit.updateFlags({
  'dashboard': true,
  'authentication': false,
});

// Get all flags
final flags = cubit.getAllFlags();
```

#### In domain/data layer (using service directly):

```dart
final service = locator<IFeatureFlagService>();
service.enable(FeatureFlag.dashboard);
```

#### Disable a feature:

```dart
final service = locator<IFeatureFlagService>();
service.disable(FeatureFlag.authentication);
```

#### Get all flags:

```dart
final service = locator<IFeatureFlagService>();
final flags = service.getAllFlags();
print(flags); // {exampleFeature: true, dashboard: true, ...}
```

#### Bulk update flags:

```dart
final service = locator<IFeatureFlagService>();
service.updateFlags({
  'dashboard': false,
  'authentication': true,
  'oauthProviders': false,
});
```

## Adding New Feature Flags

1. Add the new flag to the `FeatureFlag` enum in `feature_flag.dart`:

```dart
enum FeatureFlag {
  exampleFeature,
  dashboard,
  authentication,
  oauthProviders,
  
  /// Your new feature
  myNewFeature,
}
```

2. Use the flag in your code:

```dart
if (context.isFeatureEnabled(FeatureFlag.myNewFeature)) {
  // Feature code
}
```

## Default Behavior

- **All features are enabled by default** unless explicitly disabled
- This ensures backward compatibility and reduces the need for configuration
- Features can be selectively disabled as needed

## Future Enhancements

The current implementation is designed to support future enhancements:

### 1. Remote Configuration

```dart
@Singleton(as: IFeatureFlagService)
class RemoteFeatureFlagService implements IFeatureFlagService {
  final INetworkClient _client;
  final Map<String, bool> _localCache = {};

  Future<void> fetchRemoteFlags() async {
    final response = await _client.get('/api/feature-flags');
    response.fold(
      (failure) => log('Failed to fetch flags'),
      (res) {
        final flags = res.data as Map<String, dynamic>;
        updateFlags(flags.map((k, v) => MapEntry(k, v as bool)));
      },
    );
  }

  @override
  bool isEnabled(FeatureFlag flag) {
    return _localCache[flag.name] ?? true;
  }
  
  // ... other methods
}
```

### 2. Persistence

```dart
@Singleton(as: IFeatureFlagService)
class PersistedFeatureFlagService implements IFeatureFlagService {
  final SharedPreferences _prefs;
  
  @override
  bool isEnabled(FeatureFlag flag) {
    return _prefs.getBool('flag_${flag.name}') ?? true;
  }
  
  @override
  void enable(FeatureFlag flag) {
    _prefs.setBool('flag_${flag.name}', true);
  }
  
  // ... other methods
}
```

### 3. Analytics Integration

```dart
@override
bool isEnabled(FeatureFlag flag) {
  final enabled = _flags[flag.name] ?? true;
  analytics.logEvent('feature_flag_check', parameters: {
    'flag': flag.name,
    'enabled': enabled,
  });
  return enabled;
}
```

### 4. Variant/Multivariate Flags

Extend beyond boolean flags to support feature variants:

```dart
abstract interface class IFeatureFlagService {
  bool isEnabled(FeatureFlag flag);
  String getVariant(FeatureFlag flag); // 'A', 'B', 'C'
  T getValue<T>(FeatureFlag flag, T defaultValue);
}
```

## Testing

### Unit Testing

```dart
void main() {
  late FeatureFlagService service;

  setUp(() {
    service = FeatureFlagService();
  });

  test('should enable feature', () {
    service.disable(FeatureFlag.dashboard);
    expect(service.isEnabled(FeatureFlag.dashboard), false);
    
    service.enable(FeatureFlag.dashboard);
    expect(service.isEnabled(FeatureFlag.dashboard), true);
  });

  test('should return all flags', () {
    final flags = service.getAllFlags();
    expect(flags, isA<Map<String, bool>>());
    expect(flags.length, FeatureFlag.values.length);
  });
}
```

### Widget Testing with Mocked Service

```dart
class MockFeatureFlagService extends Mock implements IFeatureFlagService {}

void main() {
  testWidgets('should hide feature when disabled', (tester) async {
    final mockService = MockFeatureFlagService();
    when(() => mockService.isEnabled(FeatureFlag.dashboard))
        .thenReturn(false);
    
    // Override in GetIt for testing
    locator.registerSingleton<IFeatureFlagService>(mockService);
    
    await tester.pumpWidget(MyApp());
    
    expect(find.byType(DashboardScreen), findsNothing);
  });
}
```

## Best Practices

1. **Use descriptive flag names** - Make it clear what the flag controls
2. **Document flag purpose** - Add comments to the enum values
3. **Default to enabled** - Reduces configuration overhead
4. **Clean up old flags** - Remove flags for fully released features
5. **Use type-safe access** - Always use the `FeatureFlag` enum, never strings
6. **Test both states** - Test your features with flags both enabled and disabled
7. **Group related flags** - Consider hierarchical flags if needed (e.g., `payments`, `paymentsApplePay`)

## Common Patterns

### Navigation Guard

```dart
void navigateToDashboard(BuildContext context) {
  if (context.isFeatureEnabled(FeatureFlag.dashboard)) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DashboardScreen()),
    );
  } else {
    AppToast.showInfo('Feature coming soon!');
  }
}
```

### Conditional Menu Items

```dart
List<Widget> buildMenuItems(BuildContext context) {
  return [
    MenuItem(title: 'Home'),
    if (context.isFeatureEnabled(FeatureFlag.dashboard))
      MenuItem(title: 'Dashboard'),
    if (context.isFeatureEnabled(FeatureFlag.exampleFeature))
      MenuItem(title: 'Example'),
    MenuItem(title: 'Settings'),
  ];
}
```

### Feature-Gated API Calls

```dart
class MyRepository {
  Future<Either<Failure, Data>> fetchData() async {
    if (!_featureFlagService.isEnabled(FeatureFlag.newApi)) {
      return _fetchFromOldApi();
    }
    return _fetchFromNewApi();
  }
}
```

## Integration with Existing Code

The feature flag service is already registered with the dependency injection system and ready to use throughout the application. Simply:

1. Import the necessary files
2. Use `context.isFeatureEnabled(FeatureFlag.yourFlag)` in widgets
3. Inject `IFeatureFlagService` in services/repositories

No additional setup is required!
