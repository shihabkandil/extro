# OAuth Authentication Setup Guide

This guide provides instructions for configuring Google Sign-In and Apple Sign-In for the Extro application.

## Google Sign-In Configuration

### Android Setup

1. Create a project in the [Google Cloud Console](https://console.cloud.google.com/)
2. Enable the Google Sign-In API
3. Create OAuth 2.0 credentials for Android
4. Add your SHA-1 fingerprint to the credentials
5. Update `android/app/build.gradle` if needed (no Firebase required)

### iOS Setup

1. In Google Cloud Console, create OAuth 2.0 credentials for iOS
2. Add your iOS bundle identifier
3. Update `ios/Runner/Info.plist` with the following:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with your actual reversed client ID from Google Cloud Console.

## Apple Sign-In Configuration

### iOS Setup

1. Enable Sign in with Apple capability in your Apple Developer account
2. Add the Sign in with Apple capability to your app in Xcode:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the Runner target
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "Sign in with Apple"

3. Update `ios/Runner/Info.plist` if not already present:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_BUNDLE_IDENTIFIER</string>
        </array>
    </dict>
</array>
```

### Android Setup

Apple Sign-In on Android requires additional web-based configuration:

1. Configure Sign in with Apple in your Apple Developer account
2. Create a Service ID for your web application
3. Add your Android package name and SHA-256 fingerprint
4. No code changes required - the `sign_in_with_apple` package handles Android implementation

## Backend API Requirements

The backend API endpoint `POST /api/v1/user/oauth` should accept:

### Request Body
```json
{
  "token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjY4...",
  "provider": "google" // or "apple"
}
```

### Response Body
```json
{
  "id": "user-unique-id",
  "email": "user@example.com",
  "name": "User Name",
  "photoUrl": "https://example.com/photo.jpg"
}
```

The backend should:
1. Verify the token with the provider (Google or Apple)
2. Create or retrieve the user account
3. Generate an authentication session/token for the app
4. Return user information

## Testing

### Google Sign-In Testing
- Use your Google account to test
- Ensure your test device has Google Play Services installed (Android)
- Test on both debug and release builds

### Apple Sign-In Testing
- Available on iOS 13+ and macOS 10.15+
- Test with your Apple ID
- Web-based flow is used on Android

## Troubleshooting

### Google Sign-In Issues
- Verify SHA-1 fingerprint matches your signing key
- Check that the OAuth client ID matches your configuration
- Ensure Google Play Services is up to date (Android)

### Apple Sign-In Issues
- Verify Sign in with Apple capability is enabled in Xcode
- Check that your Apple Developer account has the capability enabled
- Ensure iOS version is 13.0 or higher

## Security Notes

- Never commit OAuth client secrets to version control
- Use environment variables for sensitive configuration
- Verify tokens on the backend before trusting user data
- Implement proper session management after authentication
