# Feature Flag Service - Quick Start Guide

## What Was Implemented

A complete feature flag service has been added to the Extro application, allowing you to control feature visibility and behavior throughout the app, following Clean Architecture principles and the project's Cubit state management pattern.

## Files Created

1. **Core Service Files:**
   - `lib/core/feature_flags/feature_flag.dart` - Enum defining all feature flags
   - `lib/core/feature_flags/i_feature_flag_service.dart` - Service interface
   - `lib/core/feature_flags/feature_flag_service.dart` - Local implementation
   - `lib/core/feature_flags/cubit/feature_flag_cubit.dart` - Cubit for presentation layer
   - `lib/core/feature_flags/cubit/feature_flag_state.dart` - Cubit state
   - `lib/core/feature_flags/feature_flag_extensions.dart` - Context extensions
   - `lib/core/feature_flags/feature_flag_examples.dart` - Usage examples
   - `lib/core/feature_flags/README.md` - Comprehensive documentation

2. **Developer Settings:**
   - `lib/features/developer_settings/presentation/screens/feature_flag_settings_screen.dart` - UI for managing flags

## Quick Start

### 1. Run Code Generation

Since the service uses `@Singleton` annotation from injectable and the cubit uses `@freezed`, you need to run code generation:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will:
- Register the `FeatureFlagService` with the dependency injection system
- Generate the freezed files for `FeatureFlagState`

### 2. Setup FeatureFlagCubit

Wrap your app with `BlocProvider` for `FeatureFlagCubit` in `main.dart`:

```dart
import 'package:extro/core/feature_flags/cubit/feature_flag_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await locator.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureFlagCubit(),
      child: MaterialApp(
        // ... rest of your app
      ),
    );
  }
}
```

### 3. Basic Usage in Widgets

```dart
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/feature_flag_extensions.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome'),
        
        // Only show if dashboard feature is enabled
        if (context.isFeatureEnabled(FeatureFlag.dashboard))
          DashboardWidget(),
        
        // Only show if OAuth is enabled
        if (context.isFeatureEnabled(FeatureFlag.oauthProviders))
          GoogleSignInButton(),
      ],
    );
  }
}
```

### 4. Usage in Cubits (Domain Layer)

```dart
import 'package:extro/core/di/locator.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';

class MyCubit extends Cubit<MyState> {
  final IFeatureFlagService _featureFlags;

  MyCubit({IFeatureFlagService? featureFlags})
      : _featureFlags = featureFlags ?? locator<IFeatureFlagService>(),
        super(MyState.initial());

  void doSomething() {
    if (_featureFlags.isEnabled(FeatureFlag.exampleFeature)) {
      // New implementation
    } else {
      // Legacy implementation
    }
  }
}
```

### 5. Programmatic Control (In Cubits/Services Only)

```dart
// In a cubit or service (domain/data layer)
final service = locator<IFeatureFlagService>();

// Or using the FeatureFlagCubit (presentation layer)
final cubit = context.read<FeatureFlagCubit>();

// Disable a feature
cubit.disable(FeatureFlag.exampleFeature);

// Enable a feature
cubit.enable(FeatureFlag.dashboard);

// Update multiple flags at once (useful for remote config)
cubit.updateFlags({
  'dashboard': true,
  'authentication': true,
  'oauthProviders': false,
});

// Get all flags
final allFlags = cubit.getAllFlags();
print(allFlags); // {exampleFeature: true, dashboard: false, ...}
```

## Available Feature Flags

The following feature flags are currently defined:

- `FeatureFlag.exampleFeature` - Controls example feature visibility
- `FeatureFlag.dashboard` - Controls dashboard feature visibility
- `FeatureFlag.authentication` - Controls authentication features
- `FeatureFlag.oauthProviders` - Controls OAuth provider availability

## Adding New Feature Flags

1. Open `lib/core/feature_flags/feature_flag.dart`
2. Add your new flag to the enum:

```dart
enum FeatureFlag {
  exampleFeature,
  dashboard,
  authentication,
  oauthProviders,
  
  /// My new feature
  myNewFeature,
}
```

3. Use it in your code:

```dart
if (context.isFeatureEnabled(FeatureFlag.myNewFeature)) {
  // Feature code
}
```

## Default Behavior

**All features are enabled by default** unless explicitly disabled. This ensures:
- Backward compatibility
- No configuration needed for new features
- Easy gradual rollout by selectively disabling features

## Future Enhancements

The service is designed to support:

### 1. Remote Configuration

```dart
// Future implementation
class RemoteFeatureFlagService implements IFeatureFlagService {
  Future<void> fetchFromServer() async {
    final response = await api.get('/feature-flags');
    updateFlags(response.data);
  }
}
```

### 2. Persistent Storage

```dart
// Future implementation
class PersistedFeatureFlagService implements IFeatureFlagService {
  final SharedPreferences _prefs;
  
  @override
  bool isEnabled(FeatureFlag flag) {
    return _prefs.getBool('flag_${flag.name}') ?? true;
  }
}
```

### 3. Analytics Integration

Track which features are being used and how often.

### 4. A/B Testing

Extend to support feature variants beyond boolean values.

## Example Widgets

Check `lib/core/feature_flags/feature_flag_examples.dart` for comprehensive examples including:

- Conditional rendering
- Navigation guards
- Adaptive menus
- Feature flag debug screen
- A/B testing patterns
- API endpoint switching
- Reusable `FeatureGate` widget

## Testing

### Unit Testing

```dart
void main() {
  late FeatureFlagService service;

  setUp(() {
    service = FeatureFlagService();
  });

  test('should enable and disable features', () {
    service.disable(FeatureFlag.dashboard);
    expect(service.isEnabled(FeatureFlag.dashboard), false);
    
    service.enable(FeatureFlag.dashboard);
    expect(service.isEnabled(FeatureFlag.dashboard), true);
  });
}
```

### Widget Testing

```dart
testWidgets('should hide feature when disabled', (tester) async {
  final mockService = MockFeatureFlagService();
  when(() => mockService.isEnabled(FeatureFlag.dashboard))
      .thenReturn(false);
  
  locator.registerSingleton<IFeatureFlagService>(mockService);
  
  await tester.pumpWidget(MyApp());
  
  expect(find.byType(DashboardScreen), findsNothing);
});
```

## Best Practices

1. ✅ Use the enum, never hardcode flag names as strings
2. ✅ Add comments to describe what each flag controls
3. ✅ Test your features with flags both enabled and disabled
4. ✅ Clean up old flags once features are fully released
5. ✅ Use `context.isFeatureEnabled()` in widgets for convenience
6. ✅ Inject `IFeatureFlagService` in services/cubits for testability
7. ✅ Default to enabled to reduce configuration burden

## Common Use Cases

### 1. Gradual Feature Rollout

Hide new features behind flags and enable them progressively.

### 2. A/B Testing

Show different implementations to different users.

### 3. Emergency Kill Switch

Quickly disable problematic features without deploying new code.

### 4. Development Toggles

Enable features only in development/staging environments.

### 5. Beta Features

Allow power users to opt-in to experimental features.

## Need Help?

- Read the comprehensive guide: `lib/core/feature_flags/README.md`
- Check examples: `lib/core/feature_flags/feature_flag_examples.dart`
- Follow existing patterns in the codebase

## Summary

The Feature Flag Service is now ready to use! Simply:

1. Run code generation
2. Use `context.isFeatureEnabled(FeatureFlag.yourFlag)` in widgets
3. Inject `IFeatureFlagService` in services
4. Add new flags to the enum as needed

The service is designed for future extensibility with remote configuration while providing immediate value with local in-memory storage.
