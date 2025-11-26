# Authentication Feature

This directory contains the OAuth authentication implementation for Google Sign-In and Apple Sign-In.

## Overview

The authentication feature follows the Clean Architecture pattern with three main layers:

### Domain Layer (`domain/`)
Contains business logic and interfaces:
- **Entities**: `User`, `OAuthProvider`
- **Repository Interface**: `IOAuthRepository`
- **Cubit**: `AuthCubit` with `AuthState`

### Data Layer (`data/`)
Handles data operations and API communication:
- **Models**: `UserResponse`, `OAuthRequest`
- **Repository Implementation**: `OAuthRepository`

### Presentation Layer (`presentation/`)
UI components and screens:
- **Screens**: `LoginScreen`
- **Widgets**: `SignInButton`

## Flow

1. User taps "Sign in with Google" or "Sign in with Apple" button
2. `AuthCubit.signInWithProvider()` is called
3. `OAuthRepository.getProviderToken()` initiates OAuth flow with the provider
4. Provider returns a token (ID token for Google, identity token for Apple)
5. `OAuthRepository.authenticateWithBackend()` sends the token to `POST /api/v1/user/oauth`
6. Backend verifies the token and returns user information
7. `AuthCubit` emits `AuthState.authenticated(user)`
8. User is logged in

## Backend API Contract

### Request
```http
POST /api/v1/user/oauth
Content-Type: application/json

{
  "token": "eyJhbGciOiJSUzI1NiIs...",
  "provider": "google" // or "apple"
}
```

### Response
```json
{
  "id": "user-unique-id",
  "email": "user@example.com",
  "name": "John Doe",
  "photoUrl": "https://example.com/photo.jpg"
}
```

## Setup

### Code Generation
After cloning, run:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Platform Configuration
See [OAUTH_SETUP.md](OAUTH_SETUP.md) for detailed platform-specific setup instructions.

## Dependencies
- `google_sign_in`: ^6.1.5 - Google Sign-In SDK
- `sign_in_with_apple`: ^5.0.0 - Apple Sign-In SDK

## Key Features
- No Firebase dependency required
- Clean separation of concerns
- Error handling with `Either<Failure, Success>` pattern
- Proper state management with Cubit
- Localized UI strings
- Support for both Google and Apple OAuth providers

## Testing
To test locally:
1. Configure OAuth credentials for your platform (see OAUTH_SETUP.md)
2. Run the app: `flutter run`
3. Tap the sign-in buttons
4. Verify the token is sent to the backend API
5. Check that user data is properly displayed after authentication

## Error Handling
The implementation handles several error cases:
- User cancels sign-in
- Network failures
- Invalid tokens
- Backend authentication failures
- Data processing errors

All errors are displayed to users via toast notifications with appropriate error messages.
