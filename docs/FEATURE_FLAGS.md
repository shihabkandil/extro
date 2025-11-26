# Feature Flag Service

## Overview

The Feature Flag Service provides a centralized way to control feature visibility in the application. It allows you to enable or disable features at runtime without code changes.

## Architecture

The service follows the project's dependency injection pattern:
- **Interface**: `IFeatureFlagService` - Defines the contract
- **Implementation**: `FeatureFlagService` - Registered as a singleton

## Usage

### 1. Inject the Service

In a widget:
```dart
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/providers/i_feature_flag_service.dart';

class MyWidget extends StatelessWidget {
  final IFeatureFlagService _featureFlags = locator<IFeatureFlagService>();

  @override
  Widget build(BuildContext context) {
    if (_featureFlags.isFeatureEnabled('new_dashboard')) {
      return NewDashboard();
    }
    return OldDashboard();
  }
}
```

In a Cubit:
```dart
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/providers/i_feature_flag_service.dart';

class MyCubit extends Cubit<MyState> {
  MyCubit({
    IFeatureFlagService? featureFlagService,
  })  : _featureFlagService = featureFlagService ?? locator<IFeatureFlagService>(),
        super(const MyState.initial());

  final IFeatureFlagService _featureFlagService;

  void checkFeature() {
    if (_featureFlagService.isFeatureEnabled('advanced_analytics')) {
      // Load advanced analytics
    } else {
      // Load basic analytics
    }
  }
}
```

### 2. Check Individual Feature Flags

```dart
// Simple check
bool isEnabled = featureFlagService.isFeatureEnabled('feature_key');

// With default value
bool isEnabled = featureFlagService.getFeatureFlag(
  'feature_key',
  defaultValue: true,
);
```

### 3. Get All Feature Flags

```dart
Map<String, bool> allFlags = featureFlagService.getAllFeatureFlags();

// Display in settings or debug screen
allFlags.forEach((key, value) {
  print('$key: $value');
});
```

### 4. Conditional UI Rendering

```dart
class FeatureScreen extends StatelessWidget {
  final IFeatureFlagService _featureFlags = locator<IFeatureFlagService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Always visible
        BasicFeature(),
        
        // Conditionally visible
        if (_featureFlags.isFeatureEnabled('premium_feature'))
          PremiumFeature(),
        
        // Alternative rendering
        _featureFlags.isFeatureEnabled('new_ui')
            ? NewUserInterface()
            : LegacyUserInterface(),
      ],
    );
  }
}
```

## Default Feature Flags

The service initializes with these default flags:
- `example_feature`: `true`
- `new_dashboard`: `false`
- `advanced_analytics`: `false`

## Future Extensions

The service is designed to support remote configuration in the future. Here's a detailed implementation example:

### Remote Configuration Implementation

```dart
import 'package:extro/core/providers/i_feature_flag_service.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IFeatureFlagService)
class RemoteFeatureFlagService implements IFeatureFlagService {
  final INetworkClient _client;
  final Map<String, bool> _featureFlags = {};
  
  RemoteFeatureFlagService({required INetworkClient client}) : _client = client {
    _initializeDefaults();
  }
  
  void _initializeDefaults() {
    _featureFlags['example_feature'] = true;
    _featureFlags['new_dashboard'] = false;
    _featureFlags['advanced_analytics'] = false;
  }
  
  /// Fetch feature flags from remote service
  Future<void> fetchRemoteFlags() async {
    final response = await _client.get(
      '/api/v1/feature-flags',
      requiresAuth: false,
    );
    
    response.fold(
      (failure) {
        // Log error, continue with local defaults
      },
      (res) {
        final flags = res.data as Map<String, dynamic>;
        flags.forEach((key, value) {
          if (value is bool) {
            _featureFlags[key] = value;
          }
        });
      },
    );
  }
  
  @override
  bool isFeatureEnabled(String featureKey) {
    return _featureFlags[featureKey] ?? false;
  }
  
  @override
  Map<String, bool> getAllFeatureFlags() {
    return Map.unmodifiable(_featureFlags);
  }
  
  @override
  bool getFeatureFlag(String featureKey, {bool defaultValue = false}) {
    return _featureFlags[featureKey] ?? defaultValue;
  }
}
```

### Using Remote Configuration

```dart
// In your app initialization (e.g., main.dart)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();
  
  // Fetch remote feature flags on app start
  final featureFlags = locator<IFeatureFlagService>();
  if (featureFlags is RemoteFeatureFlagService) {
    await featureFlags.fetchRemoteFlags();
  }
  
  runApp(const MyApp());
}
```

### Periodic Refresh

```dart
class FeatureFlagRefreshService {
  final IFeatureFlagService _featureFlags;
  Timer? _refreshTimer;
  
  FeatureFlagRefreshService({required IFeatureFlagService featureFlags})
      : _featureFlags = featureFlags;
  
  void startPeriodicRefresh({Duration interval = const Duration(hours: 1)}) {
    _refreshTimer = Timer.periodic(interval, (_) async {
      if (_featureFlags is RemoteFeatureFlagService) {
        await (_featureFlags as RemoteFeatureFlagService).fetchRemoteFlags();
      }
    });
  }
  
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
  }
}
```

## Best Practices

1. **Use Descriptive Keys**: Use clear, descriptive names for feature flags
   - ✅ `new_transaction_flow`
   - ❌ `flag1`

2. **Default to Safe Values**: Default to `false` for new features to prevent accidental exposure

3. **Inject via Constructor**: Follow the project pattern of constructor injection with locator fallback

4. **Clean Up Old Flags**: Remove feature flags once features are permanently enabled

5. **Document Feature Flags**: Keep track of active feature flags and their purpose

## Testing

Mock the service in tests:
```dart
class MockFeatureFlagService extends Mock implements IFeatureFlagService {}

void main() {
  test('feature is hidden when flag is disabled', () {
    final mockService = MockFeatureFlagService();
    when(() => mockService.isFeatureEnabled('feature_key')).thenReturn(false);
    
    final widget = MyWidget(featureFlagService: mockService);
    // Assert feature is not visible
  });
}
```

## Integration with Clean Architecture

The Feature Flag Service follows the project's architecture:
- Located in `lib/core/providers/`
- Registered with `@Singleton` annotation
- Interface-based design for testability
- Compatible with dependency injection
