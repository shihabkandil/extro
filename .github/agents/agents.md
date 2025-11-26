# Coding Guidelines for AI Agents

## General Principles

### Comments
- **Avoid writing comments** unless it's a complex logic or something that truly needs clarification
- Code should be self-documenting with clear variable and function names
- Only add comments for:
  - Complex algorithms or business logic
  - Non-obvious workarounds
  - Important architectural decisions
  - Public API documentation

### Code Organization

#### Widget Structure
- Extract stateless widgets into separate files in a `widgets` directory within the feature
- Follow the project's feature-based structure: `lib/features/{feature}/presentation/widgets/`
- Each widget should be in its own file with a descriptive name
- Private widgets (prefixed with `_`) used only within a single file should remain in that file

#### File Naming
- Use snake_case for file names (e.g., `metric_card.dart`, `transaction_tile.dart`)
- Widget file names should match the widget class name in snake_case

### Theme and Styling

#### Use Context Extensions
- **Always use theme and textTheme extensions** from `context_extensions.dart`
- Instead of `Theme.of(context)`, use `context.theme`
- Instead of `Theme.of(context).textTheme`, use `context.textTheme`
- Instead of hardcoded TextStyles, prefer using theme text styles:
  ```dart
  // Bad
  Text('Title', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
  
  // Good
  Text('Title', style: context.textTheme.headlineLarge)
  ```

#### Available Context Extensions
- `context.localizer` - for localization
- `context.theme` - for theme data
- `context.textTheme` - for text theme
- `context.colorScheme` - for color scheme
- `context.mediaQuery` - for media query
- `context.screenSize` - for screen size
- `context.screenWidth` - for screen width
- `context.screenHeight` - for screen height

### Localization

#### Generated Files
- Localization Dart files (`app_localizations.dart`, `app_localizations_*.dart`) are **generated files**
- They should be listed in `.gitignore`
- Only the ARB files (`app_en.arb`, etc.) should be committed
- Generated files are created by running `flutter gen-l10n`

### Code Style

#### Imports
- Group imports: Flutter SDK, packages, local files
- Use relative imports for files within the same feature
- Use absolute imports for cross-feature references

#### Constants
- Define all colors in `AppColors` class
- Define all dimensions/spacing as constants when reused
- Use const constructors wherever possible

#### State Management
- Use BLoC/Cubit for state management
- Follow the repository pattern for data access
- Keep business logic in the domain layer

## Best Practices

### Performance
- Use `const` constructors whenever possible
- Avoid rebuilding widgets unnecessarily
- Use `ListView.builder` for long lists instead of `ListView`

### Accessibility
- Provide semantic labels for interactive elements
- Ensure proper contrast ratios for text
- Use SafeArea for proper layout on all devices

### Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Follow existing test patterns in the project

## Examples

### Good Widget Structure
```dart
// lib/features/dashboard/presentation/widgets/metric_card.dart
import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final List<Color> gradientColors;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(label, style: context.textTheme.labelMedium),
          Text(value, style: context.textTheme.headlineLarge),
        ],
      ),
    );
  }
}
```

### Using Theme Extensions
```dart
// Good
Text(
  'Welcome',
  style: context.textTheme.headlineMedium?.copyWith(
    color: AppColors.primary,
  ),
)

// Bad
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```
