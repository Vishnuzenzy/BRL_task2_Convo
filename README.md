# Convo - Authentication & Session Persistence App

A robust Flutter authentication application implementing MVVM architecture, persistent authentication states, Google Sign-In, and local session management.


---# Convo - Authentication & Session Persistence App

A robust Flutter authentication application implementing MVVM architecture, persistent authentication states, Google Sign-In, and local session management.


---

## Features
- **Email & Password Authentication**: Validated sign-up, sign-in, and error feedback via SnackBar.
- **Google Sign-In**: One-tap sign-in integrated via Firebase Auth.
- **Persistent Sessions**: Instant auto-login across app restarts using reactive auth state streams.
- **Local Storage Management**: App-specific session metadata (login method & timestamp) tracked via `SharedPreferences`, completely purged upon logout.
- **Profile & Account Management**: Displays active profile information (name, email, avatar) and secure logout with confirmation dialog.
- **Royal-Blue UI Theme**: Clean, minimal, and responsive design system.

---

## Tech Stack & Architecture
- **Framework**: Flutter (Dart)
- **State Management**: Provider (MVVM Architecture)
- **Authentication**: Firebase Auth & Google Sign-In
- **Local Storage**: `shared_preferences`

### Project Structure (MVVM)
```text
lib/
├── core/
│   ├── theme/
│   └── utils/
├── features/
│   └── auth/
│       ├── data/             # AuthService & LocalSessionService
│       ├── models/           # Data models
│       ├── viewmodels/       # AuthViewModel (ChangeNotifier)
│       └── views/            # Login, Signup, Home screens
├── firebase_options.dart
└── main.dart

## Features
- **Email & Password Authentication**: Validated sign-up, sign-in, and error feedback via SnackBar.
- **Google Sign-In**: One-tap sign-in integrated via Firebase Auth.
- **Persistent Sessions**: Instant auto-login across app restarts using reactive auth state streams.
- **Local Storage Management**: App-specific session metadata (login method & timestamp) tracked via `SharedPreferences`, completely purged upon logout.
- **Profile & Account Management**: Displays active profile information (name, email, avatar) and secure logout with confirmation dialog.
- **Royal-Blue UI Theme**: Clean, minimal, and responsive design system.

---

## Tech Stack & Architecture
- **Framework**: Flutter (Dart)
- **State Management**: Provider (MVVM Architecture)
- **Authentication**: Firebase Auth & Google Sign-In
- **Local Storage**: `shared_preferences`

### Project Structure (MVVM)
```text
lib/
├── core/
│   ├── theme/
│   └── utils/
├── features/
│   └── auth/
│       ├── data/             # AuthService & LocalSessionService
│       ├── models/           # Data models
│       ├── viewmodels/       # AuthViewModel (ChangeNotifier)
│       └── views/            # Login, Signup, Home screens
├── firebase_options.dart
└── main.dart

#Getting Started
###Prerequisites
>> Flutter SDK installed
>> Android SDK / Device with Developer Options enabled

Installation & Run
Bash
# Clone the repository
git clone <YOUR_REPO_URL>
cd convo

# Get packages
flutter pub get

# Run the app
flutter run