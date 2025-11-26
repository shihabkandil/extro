# Feature Flag Implementation - Architecture Overview

## Clean Architecture Implementation

This feature flag system follows the project's clean architecture principles and Cubit state management pattern:

### Layer Separation

```
┌─────────────────────────────────────────────┐
│         Presentation Layer                   │
│  - FeatureFlagSettingsScreen (UI)           │
│  - context.isFeatureEnabled() extension      │
│  - BlocProvider<FeatureFlagCubit>           │
└──────────────────┬──────────────────────────┘
                   │ uses
┌──────────────────▼──────────────────────────┐
│         Domain Layer (Cubit)                 │
│  - FeatureFlagCubit (state management)      │
│  - FeatureFlagState (freezed)               │
│  - Constructor injection with locator        │
│    fallback: featureFlags ?? locator<>()    │
└──────────────────┬──────────────────────────┘
                   │ depends on
┌──────────────────▼──────────────────────────┐
│         Domain Layer (Interface)             │
│  - IFeatureFlagService (abstract interface) │
└──────────────────┬──────────────────────────┘
                   │ implemented by
┌──────────────────▼──────────────────────────┐
│         Data Layer                           │
│  - FeatureFlagService (@Singleton)          │
│  - In-memory storage                         │
│  - Injectable with DI                        │
└─────────────────────────────────────────────┘
```

## Key Design Decisions

### 1. No Direct Locator Access in Presentation Layer

❌ **Wrong (violates clean architecture):**
```dart
// In context extension
bool isFeatureEnabled(FeatureFlag flag) {
  return locator<IFeatureFlagService>().isEnabled(flag);
}
```

✅ **Correct (uses Cubit):**
```dart
// In context extension
bool isFeatureEnabled(FeatureFlag flag) {
  return read<FeatureFlagCubit>().isEnabled(flag);
}
```

### 2. Cubit Pattern for State Management

Following the project's existing patterns (AuthCubit, ExampleCubit), feature flags are managed through a cubit:

```dart
class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final IFeatureFlagService _service;

  FeatureFlagCubit({
    IFeatureFlagService? service,  // ✅ Constructor injection
  })  : _service = service ?? locator<IFeatureFlagService>(),  // ✅ Fallback to locator
        super(FeatureFlagState(flags: {})) {
    _loadFlags();
  }
  
  // ... methods
}
```

### 3. BlocProvider Setup

The cubit is provided at the app root:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureFlagCubit(),
      child: MaterialApp(/* ... */),
    );
  }
}
```

## Usage Patterns

### In Widgets (Presentation Layer)

```dart
// Using context extension
if (context.isFeatureEnabled(FeatureFlag.dashboard)) {
  return DashboardWidget();
}

// Using BlocBuilder for reactive UI
BlocBuilder<FeatureFlagCubit, FeatureFlagState>(
  builder: (context, state) {
    if (state.flags['dashboard'] ?? true) {
      return DashboardWidget();
    }
    return PlaceholderWidget();
  },
)
```

### In Cubits (Domain Layer)

```dart
class MyCubit extends Cubit<MyState> {
  final IFeatureFlagService _featureFlags;

  MyCubit({IFeatureFlagService? featureFlags})
      : _featureFlags = featureFlags ?? locator<IFeatureFlagService>(),
        super(MyState.initial());
  
  void checkFeature() {
    if (_featureFlags.isEnabled(FeatureFlag.newFeature)) {
      // New implementation
    }
  }
}
```

### In Repositories (Data Layer)

```dart
@Singleton(as: IMyRepository)
class MyRepository implements IMyRepository {
  final IFeatureFlagService _featureFlags;
  
  MyRepository({required IFeatureFlagService featureFlags})
      : _featureFlags = featureFlags;
  
  Future<Data> getData() async {
    final endpoint = _featureFlags.isEnabled(FeatureFlag.newApi)
        ? Endpoints.v2Api
        : Endpoints.v1Api;
    // ...
  }
}
```

## Benefits of This Architecture

1. **Testability**: Easy to mock `IFeatureFlagService` in tests
2. **Clean separation**: Presentation layer doesn't know about service locator
3. **Type safety**: Using enum instead of strings
4. **Reactive UI**: State updates trigger UI rebuilds automatically
5. **Follows project patterns**: Consistent with existing cubits
6. **Future-proof**: Easy to swap implementation (local → remote)

## Migration to Remote Configuration

When ready to fetch flags from a remote service:

```dart
class RemoteFeatureFlagService implements IFeatureFlagService {
  final INetworkClient _client;
  final Map<String, bool> _cache = {};
  
  Future<void> fetchFromRemote() async {
    final response = await _client.get('/api/feature-flags');
    // Update local cache
    updateFlags(response.data);
  }
  
  @override
  bool isEnabled(FeatureFlag flag) {
    return _cache[flag.name] ?? true;
  }
  
  // ... other methods
}
```

Then just change the DI registration:

```dart
@Singleton(as: IFeatureFlagService)
class RemoteFeatureFlagService implements IFeatureFlagService {
  // New implementation
}
```

No changes needed in presentation or domain layers! ✨

## Code Generation Required

Run these commands to generate necessary files:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `feature_flag_state.freezed.dart` - Freezed state class
- `locator.config.dart` - Injectable DI registration
