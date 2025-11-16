# Post-Implementation Steps

This document outlines the steps required to complete the authentication feature implementation after the code has been merged.

## Required Steps After Merge

### 1. Install Flutter Dependencies

```bash
flutter pub get
```

This will download the new packages:
- `google_sign_in: ^6.1.5`
- `sign_in_with_apple: ^5.0.0`

### 2. Run Code Generation

The implementation uses Freezed and Injectable which require code generation:

```bash
# Clean previous builds
flutter clean

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n
```

This will generate:
- `*.freezed.dart` files for immutable models and states
- `*.g.dart` files for JSON serialization
- `injection.config.dart` for dependency injection
- Localization files in `lib/gen/`

### 3. Configure OAuth Providers

Follow the detailed setup guide in [docs/OAUTH_SETUP.md](OAUTH_SETUP.md):

#### For Google Sign-In:
1. Create a project in Google Cloud Console
2. Enable Google Sign-In API
3. Create OAuth 2.0 credentials for Android and iOS
4. Update `ios/Runner/Info.plist` with reversed client ID

#### For Apple Sign-In:
1. Enable Sign in with Apple in Apple Developer Portal
2. Add capability in Xcode (iOS only)
3. Configure Service ID for Android web-based flow

### 4. Update Backend API URL

Update the base URL in `lib/core/network/endpoints.dart`:

```dart
static const String baseUrl = 'https://your-actual-api.com';
```

### 5. Verify Backend API

Ensure your backend implements the required endpoint:

**Endpoint**: `POST /api/v1/user/oauth`

**Request**:
```json
{
  "token": "provider_id_token",
  "provider": "google" // or "apple"
}
```

**Response**:
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "photoUrl": "https://photo.url"
}
```

The backend MUST:
- Verify the token with Google/Apple
- Create or retrieve the user account
- Return user information

### 6. Test the Implementation

#### On Android:
```bash
flutter run -d android
```

1. Tap "Sign in with Google"
2. Select a Google account
3. Verify the token is sent to backend
4. Check that you're redirected after successful auth

#### On iOS:
```bash
flutter run -d ios
```

1. Test both Google and Apple Sign-In
2. Verify proper error handling
3. Check that user info is displayed correctly

### 7. Handle Edge Cases

Test these scenarios:
- [ ] User cancels sign-in
- [ ] No internet connection
- [ ] Backend API is down
- [ ] Invalid token from provider
- [ ] User denies permissions

All should show appropriate error messages via toast notifications.

## File Structure Overview

The implementation creates these files:

```
lib/features/auth/
├── data/
│   ├── models/
│   │   ├── oauth_request.dart              # Request to backend
│   │   ├── oauth_request.freezed.dart      # Generated
│   │   ├── user_response.dart              # Backend response
│   │   ├── user_response.freezed.dart      # Generated
│   │   └── user_response.g.dart            # Generated
│   └── repositories/
│       └── oauth_repository.dart           # OAuth implementation
├── domain/
│   ├── cubits/
│   │   └── auth_cubit/
│   │       ├── auth_cubit.dart             # State management
│   │       ├── auth_state.dart             # Auth states
│   │       └── auth_state.freezed.dart     # Generated
│   ├── entities/
│   │   ├── oauth_provider.dart             # Provider enum
│   │   ├── user.dart                       # User entity
│   │   └── user.freezed.dart               # Generated
│   └── repositories/
│       └── i_oauth_repository.dart         # Repository interface
└── presentation/
    ├── screens/
    │   └── login_screen.dart               # Login UI
    └── widgets/
        └── sign_in_button.dart             # Sign-in button widget
```

## Troubleshooting

### Build Errors After Merge

If you see errors about missing generated files:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Google Sign-In Not Working

1. Check SHA-1 fingerprint matches credentials
2. Verify OAuth client ID in Google Cloud Console
3. Check bundle ID/package name matches

### Apple Sign-In Not Working

1. Verify iOS version is 13.0+
2. Check Sign in with Apple capability is enabled
3. Ensure Apple Developer account has the capability

### Backend Integration Issues

1. Check network logs in console
2. Verify API base URL is correct
3. Test backend endpoint with curl:
```bash
curl -X POST https://your-api.com/api/v1/user/oauth \
  -H "Content-Type: application/json" \
  -d '{"token":"test_token","provider":"google"}'
```

## Next Steps

After successful testing:

1. **Update Environment Config**: Use different OAuth credentials for dev/staging/prod
2. **Add Analytics**: Track authentication success/failure rates
3. **Implement Token Refresh**: If using long-lived sessions
4. **Add Biometric Auth**: As a second factor for enhanced security
5. **User Profile Screen**: Build screen to display authenticated user info
6. **Sign Out Flow**: Implement proper cleanup on sign out

## Support

- Review [OAUTH_SETUP.md](OAUTH_SETUP.md) for platform configuration
- Check [SECURITY_REVIEW.md](SECURITY_REVIEW.md) for security considerations
- See [ARCHITECTURE.md](ARCHITECTURE.md) for code organization patterns
- Refer to [CODING_GUIDELINES.md](CODING_GUIDELINES.md) for style conventions

## Verification Checklist

Before considering the feature complete:

- [ ] Dependencies installed
- [ ] Code generation successful
- [ ] OAuth providers configured
- [ ] Backend API implemented
- [ ] Android build successful
- [ ] iOS build successful
- [ ] Google Sign-In tested
- [ ] Apple Sign-In tested
- [ ] Error cases handled
- [ ] Documentation reviewed
- [ ] Security review completed
