# Tic Tac Toe Flutter App - Complete Setup Guide

A Flutter-based Tic Tac Toe game with Firebase authentication, real-time leaderboard, and AI opponent (Easy/Medium/Hard difficulty levels).

## Team
- **IJAN (Hafizhan Yusra Sulistyo - 5026231060)**: Authentication, Navigation, UI/UX
- **Zeldano Shan Oeffie (5026231118)**: Game Logic, AI Algorithm, Game Provider

---

## Prerequisites

Before you start, make sure you have installed:

- **Flutter** (latest stable): [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **VS Code** with Flutter extension
- **Java Development Kit (JDK)** 17+
- **Git**

### Verify Installation
```bash
flutter doctor
```
Ensure all green checkmarks (except iOS if not on macOS).

---

## 1. Project Setup

### Step 1.1: Clone Repository
```bash
git clone <repository-url>
cd tictactoe_fp_tekber
```

### Step 1.2: Install Dependencies
```bash
flutter pub get
```

### Step 1.3: Setup Android Emulator (if needed)
- Open **Android Studio** → **Tools** → **Device Manager**
- Click **Create Device** if no emulator exists
- Select device profile (e.g., Pixel 5)
- Select API level (API 34 or higher recommended)
- Click **Finish** and wait for download
- Click play icon to launch emulator

Verify emulator is running:
```bash
flutter devices
```

---

## 2. Firebase Setup (Step-by-Step)

### Step 2.1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Create Project**
3. Enter project name: `tictactoe_fp_tekber`
4. Enable Google Analytics (optional)
5. Click **Create Project**

### Step 2.2: Enable Authentication
1. In Firebase Console: **Build** → **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** provider
4. Click **Save**

### Step 2.3: Create Firestore Database
1. In Firebase Console: **Build** → **Firestore Database**
2. Click **Create Database**
3. Select **Start in test mode**
4. Choose region (e.g., `asia-southeast1` for Indonesia)
5. Click **Enable**

### Step 2.4: Create Collections & Set Security Rules
1. Click **Start Collection** → name: `users`
2. Click **Start Collection** → name: `game_results`
3. Go to **Rules** tab and paste security rules (see below)
4. Click **Publish**

**Firestore Security Rules:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth.uid == userId || request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    match /game_results/{gameId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### Step 2.5: Register Android App
1. In Firebase Console: **Project Settings** (⚙️ icon)
2. Tab **Your apps** → Click **Add app** → Select **Android**
3. Enter **Android package name**: `com.example.tictactoe_fp_tekber`
4. Enter **App nickname**: `Tic Tac Toe` (optional)
5. Click **Register app**
6. Download `google-services.json`
7. Paste into: `android/app/google-services.json`

### Step 2.6: Generate Firebase Options
```bash
flutterfire configure
```
- Choose your Firebase project when prompted
- Select Android platform (and Web if needed)
- Confirm to overwrite `lib/firebase_options.dart`

---

## 3. Running the App

### Option 1: Android Emulator (Recommended)
```bash
flutter run -d android
```

### Option 2: Specific Emulator
```bash
flutter devices  # Get emulator ID
flutter run -d emulator-5554
```

### Option 3: Android Studio
1. Open Android Studio → Open project folder
2. Wait for Gradle sync to complete
3. Click **Run** (Shift+F10) or click play button
4. Select emulator/device

**App will launch in 1-2 minutes on first run.**

---

## 4. App Features & Testing

### Authentication Flow
- **Register**: Create account with email, password, unique username
- **Login**: Sign in with registered credentials
- **Logout**: Sign out from app

### Game Screen
- **Difficulty**: Easy/Medium/Hard AI
- **Board**: 3x3 grid, tap to place mark
- **AI Opponent**: Responds based on difficulty
- **Result**: Win/Loss/Draw notification

### Leaderboard
- **Real-time Ranking**: Top 10 players by score
- **Auto-update**: Updates when games finish

### Profile
- **User Stats**: Games, wins, highest score
- **User Info**: Username, email

### Testing Checklist
- [ ] Register & check `/users` collection in Firebase
- [ ] Login successfully
- [ ] Navigate all screens
- [ ] Play game vs AI (all difficulties)
- [ ] Verify `/game_results` collection has entries
- [ ] Check leaderboard updates

---

## 5. Project Structure

```
lib/
├── main.dart                    # App bootstrap
├── router.dart                  # Go Router + auth guard
├── firebase_options.dart        # Firebase config
├── constants/
│   ├── app_colors.dart
│   └── app_theme.dart
├── models/
│   ├── user_model.dart
│   └── game_result_model.dart
├── services/
│   ├── firebase/
│   │   ├── auth_service.dart
│   │   └── firestore_service.dart
│   └── game_engine/
│       ├── game_logic.dart (TODO: Zeldano)
│       └── ai_player.dart (TODO: Zeldano)
├── providers/
│   ├── auth_provider.dart
│   └── game_provider.dart (TODO: Zeldano)
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── game/
│   │   └── game_screen.dart (TODO: Zeldano)
│   ├── leaderboard/
│   │   └── leaderboard_screen.dart (TODO: Zeldano)
│   └── profile/
│       └── profile_screen.dart (TODO: Zeldano)
└── widgets/
    └── app_text_field.dart
```

---

## 6. Scoring System

| Result | Points |
|--------|--------|
| Win    | 10     |
| Draw   | 5      |
| Loss   | 0      |

---

## 7. Development Commands

### Hot Reload (fast)
```bash
flutter run -d android
# Press 'r' in terminal
```

### Hot Restart (full reload)
```bash
flutter run -d android
# Press 'R' in terminal
```

### Clean Build
```bash
flutter clean
./android/gradlew.bat clean
flutter pub get
flutter run -d android
```

### Build Release APK
```bash
flutter build apk --release
```

---

## 8. Troubleshooting

### "No devices found"
```bash
flutter devices
flutter emulators --launch <emulator-name>
```

### Firebase errors
- Check `google-services.json` in `android/app/`
- Verify authentication & Firestore enabled in Firebase
- Check security rules are published

### Gradle errors
```bash
flutter clean
./android/gradlew.bat clean
flutter pub get
flutter run -d android
```

---

## 9. Git Workflow

### Commit Changes
```bash
git add .
git commit -m "feat: implement feature name"
git push origin main
```

### Branches (Optional)
```bash
git checkout -b feature/game-logic
git checkout main
git merge feature/game-logic
```

---

## Resources

- [Flutter Docs](https://flutter.dev)
- [Firebase Flutter](https://firebase.flutter.dev)
- [Riverpod](https://riverpod.dev)
- [Go Router](https://pub.dev/packages/go_router)

---

## Additional Documentation

- See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed technical notes

---

**Last Updated**: December 19, 2025  
**Course**: ES234527 – Emerging Technology  
**Deadline**: December 19, 2025
