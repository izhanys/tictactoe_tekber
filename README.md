# Tic Tac Toe - Flutter Application

## Project Overview

A modern Flutter-based Tic Tac Toe game application with Firebase authentication, real-time leaderboard, AI opponent, and sound effects. The application features user registration/login, game mechanics with AI difficulty levels, and persistent game statistics.

---

## Team Members

| No. | Name | Student ID | Role | Responsibilities |
|-----|------|-----------|------|------------------|
| 1 | **Hafizhan Yusra Sulistyo** | 5026231060 | **Authentication & Navigation** | User registration/login, authentication flows, app routing, UI/UX setup |
| 2 | **Zeldano Shan Oeffie** | 5026231118 | **Game Logic & AI** | Game engine, AI algorithms, game state management, game provider |

## 🏗️ Project Structure & File Description

### **Complete Directory Structure**

```
tictactoe_fp_tekber/
├── lib/                                  # Main application source code
│   ├── main.dart                          # App entry point with Firebase init
│   ├── router.dart                        # Navigation routing with auth guard
│   ├── firebase_options.dart             # Firebase configuration (auto-generated)
│   │
│   ├── constants/
│   │   ├── app_colors.dart              # Material Design 3 color palette
│   │   └── app_theme.dart               # Theme configuration
│   │
│   ├── models/
│   │   ├── user_model.dart              # User profile data structure
│   │   └── game_result_model.dart       # Game result data structure
│   │
│   ├── providers/
│   │   └── auth_provider.dart           # Riverpod auth state management
│   │
│   ├── services/
│   │   ├── audio_service.dart           # Sound effects management
│   │   ├── firebase/
│   │   │   ├── auth_service.dart        # Firebase authentication
│   │   │   └── firestore_service.dart   # Firestore database operations
│   │   └── game_engine/
│   │       ├── game_logic.dart          # Core game mechanics
│   │       └── ai_player.dart           # AI opponent algorithms
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart        # User login UI
│   │   │   └── register_screen.dart     # User registration UI
│   │   ├── game/
│   │   │   └── game_screen_placeholder.dart  # Game board UI
│   │   ├── leaderboard/
│   │   │   └── leaderboard_screen_placeholder.dart  # Leaderboard display
│   │   ├── profile/
│   │   │   └── profile_screen_placeholder.dart      # User profile
│   │   └── menu/
│   │       └── menu_screen.dart         # Main menu
│   │
│   └── widgets/
│       └── app_text_field.dart          # Reusable text input
│
├── android/                              # Android native code
│   ├── app/
│   │   ├── build.gradle.kts             # App-level build config (with Firebase)
│   │   ├── google-services.json         # Firebase credentials
│   │   └── src/
│   └── build.gradle.kts                 # Project-level build config
│
├── assets/
│   └── sounds/
│       ├── tap.mp3                      # Tap sound effect
│       ├── win.mp3                      # Win sound effect
│       └── lose.mp3                     # Lose sound effect
│
├── test/                                 # Unit tests
│   └── widget_test.dart
│
├── pubspec.yaml                         # Flutter dependencies configuration
├── pubspec.lock                         # Locked dependency versions
├── firebase.json                        # Firebase configuration
├── analysis_options.yaml                # Dart analyzer configuration
├── SETUP_GUIDE.md                       # Detailed setup instructions
├── FIREBASE_SETUP.md                    # Firebase configuration guide
└── README.md                            # This file
```

---

## 📋 Detailed File Documentation

### **Core Application Files**

#### `lib/main.dart` 🚀
**Purpose:** Application entry point and Firebase initialization
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}
```
- Initializes Firebase with platform-specific options
- Sets up Riverpod ProviderScope for state management
- Wraps app in MaterialApp.router with GoRouter configuration
- Applies Material Design 3 theme

#### `lib/router.dart` 🗺️
**Purpose:** Navigation routing system with authentication guard
- **Route Definitions:** `/login`, `/register`, `/menu`, `/game`, `/leaderboard`, `/profile`
- **Auth Guard:** Redirects unauthenticated users to `/login`
- **Initial Route:** Determined by authentication state
- **Protected Routes:** Game, leaderboard, profile require authentication

**Example:** User tries to access `/game` without login → Auto-redirect to `/login`

#### `lib/firebase_options.dart` 🔐
**Purpose:** Platform-specific Firebase configuration (auto-generated)
- Contains Firebase project credentials
- Different configs for Android, iOS, Web, macOS, Windows
- Generated by Firebase CLI during setup

---

### **Authentication & State Management**

#### `lib/providers/auth_provider.dart` 📊
**Purpose:** User authentication state management using Riverpod
```dart
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  Future<void> register(String email, String password, String username) async { }
  Future<void> login(String email, String password) async { }
  Future<void> logout() async { }
}
```
- Manages current user state (loading, error, authenticated)
- Provides reactive state for UI components
- Handles authentication operations (register, login, logout)
- Exposes `isAuthenticatedProvider` boolean for route guards

---

### **Services Layer**

#### `lib/services/firebase/auth_service.dart` 🔑
**Purpose:** Firebase Authentication operations

**Key Methods:**

| Method | Description |
|--------|-------------|
| `register(email, password, username)` | Creates user account in Firebase Auth & saves to Firestore |
| `login(email, password)` | Authenticates user with email/password |
| `logout()` | Signs out current user |
| `getCurrentUser()` | Fetches current authenticated user |
| `usernameExists(username)` | Checks username uniqueness before registration |

**Error Handling:**
- `weak-password` → "Password must be at least 6 characters"
- `email-already-in-use` → "Email already registered"
- `user-not-found` → "Email not found"
- `wrong-password` → "Incorrect password"

---

#### `lib/services/firebase/firestore_service.dart` 📚
**Purpose:** Firestore database operations

**Collections:**

**`users/` Collection**
```
Document ID: {user_id}
{
  uid: "user_id_123",
  email: "player@example.com",
  username: "player_name",
  totalGamesPlayed: 10,
  totalWins: 7,
  highestScore: 70,
  createdAt: Timestamp(2025-12-19...)
}
```

**`game_results/` Collection**
```
Document ID: Auto-generated
{
  userId: "user_id_123",
  result: "win" | "draw" | "loss",
  pointsEarned: 10,
  opponent: "easy" | "medium" | "hard",
  gameDate: Timestamp(2025-12-19...)
}
```

**Key Methods:**

| Method | Description |
|--------|-------------|
| `saveGameResult(userId, result, points, opponent)` | Records game outcome to Firestore |
| `updateUserStats(userId, result, pointsEarned)` | Updates user profile stats |
| `streamTopLeaderboard(limit)` | Returns Stream<List<UserModel>> for real-time leaderboard |
| `getUserRank(userId)` | Gets user's current rank |
| `getLeaderboardByWins()` | Queries leaderboard sorted by wins |

---

#### `lib/services/audio_service.dart` 🔊
**Purpose:** Sound effects management

**Sound Files:**
- `assets/sounds/tap.mp3` (100-200ms) - Played on board tap
- `assets/sounds/win.mp3` (400-500ms) - Played when player wins
- `assets/sounds/lose.mp3` (400-500ms) - Played when AI wins

**Key Methods:**

| Method | Description |
|--------|-------------|
| `playSound(soundName)` | Play sound effect by name |
| `stopSound()` | Stop currently playing sound |
| `setVolume(volume)` | Set volume 0.0-1.0 |
| `dispose()` | Cleanup audio player resources |

**Implementation Example:**
```dart
final _audio = AudioService();
_audio.playSound('tap');      // Play tap sound
_audio.playSound('win');      // Play win sound
_audio.playSound('lose');     // Play lose sound
```

---

#### `lib/services/game_engine/game_logic.dart` 🎮
**Purpose:** Core game mechanics and board management

**Board Representation:**
```
List<List<String>> board  // 3x3 grid
'' = empty, 'X' = player, 'O' = AI
```

**Key Methods:**

| Method | Description |
|--------|-------------|
| `makeMove(row, col, player)` | Execute move, check win, trigger audio |
| `checkWinner()` | Returns 'X', 'O', or null |
| `isBoardFull()` | Returns true if board filled (draw) |
| `getEmptyCells()` | Returns list of available moves |
| `getResultString(playerSymbol)` | Returns 'win', 'loss', or 'draw' |
| `reset()` | Clear board for new game |

**Win Conditions Detected:**
- ✓ Three in a row (horizontal)
- ✓ Three in a column (vertical)  
- ✓ Three in diagonal (both directions)

**Audio Integration:**
```dart
bool makeMove(int row, int col, String player) {
  _audioService.playSound('tap');      // Sound on valid move
  
  if (winner == 'X') {
    _audioService.playSound('win');    // Player won
  } else if (winner == 'O') {
    _audioService.playSound('lose');   // AI won
  }
  return true;
}
```

---

#### `lib/services/game_engine/ai_player.dart` 🤖
**Purpose:** AI opponent with difficulty levels

**Difficulty Levels:**

| Level | Algorithm | Behavior |
|-------|-----------|----------|
| **Easy** | Random | Picks random available cell |
| **Medium** | Basic Strategy | Blocks player wins, seeks own wins |
| **Hard** | Minimax | Optimal play, unbeatable |

**Key Methods:**

| Method | Description |
|--------|-------------|
| `getMove(gameLogic, difficulty)` | Returns AI's next move [row, col] |
| `evaluateMove(row, col, gameLogic)` | Scores a potential move |

---

### **Data Models**

#### `lib/models/user_model.dart` 👤
**Purpose:** User profile data structure with Firestore serialization

**Fields:**
```dart
class UserModel {
  final String uid;                    // Unique Firebase user ID
  final String email;                  // User email address
  final String username;               // Unique username (3+ chars)
  final int totalGamesPlayed;         // Career game count
  final int totalWins;                // Career wins
  final int highestScore;             // Best score ever
  final DateTime createdAt;           // Account creation date
}
```

**Methods:**
- `toMap()` - Converts to Map for Firestore storage
- `fromMap()` - Constructs UserModel from Firestore data
- `copyWith()` - Creates modified copy with some fields changed

---

#### `lib/models/game_result_model.dart` 🏆
**Purpose:** Individual game result recording

**Fields:**
```dart
class GameResultModel {
  final String id;                    // Document ID
  final String userId;                // Player's UID
  final String result;                // 'win' | 'draw' | 'loss'
  final int pointsEarned;            // 10 | 5 | 0
  final String opponent;              // 'easy' | 'medium' | 'hard'
  final DateTime gameDate;           // When game was played
}
```

**Scoring System:**
- **Win:** 10 points
- **Draw:** 5 points
- **Loss:** 0 points

---

### **UI Components & Screens**

#### `lib/constants/app_colors.dart` 🎨
**Purpose:** Centralized Material Design 3 color palette

**Color Definitions:**
- **Primary:** Indigo (#6366F1)
- **Secondary:** Cyan (#06B6D4)
- **Tertiary:** Purple (#A855F7)
- **Error:** Red (#EF4444)
- **Success:** Green (#10B981)
- **Warning:** Amber (#F59E0B)
- **Surface, OnSurface:** Gray shades

**Usage:** `Colors.indigo, AppColors.success, AppColors.error`

---

#### `lib/constants/app_theme.dart` 🎭
**Purpose:** Theme configuration for Material Design 3

**Components:**
- Light & Dark themes
- Custom button styles (filled, outlined, text)
- Input decoration (borders, focus colors, corner radius)
- Typography (headline, title, body, label styles)

**Usage:** Applied globally in `main.dart` via `MaterialApp.router`

---

#### `lib/widgets/app_text_field.dart` 📝
**Purpose:** Reusable text input component

**Features:**
- Email/password/username input fields
- Label and hint text
- Input validation support
- Password visibility toggle
- Prefix/suffix icons
- Material Design 3 styling

**Constructor:**
```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  obscureText: false,
  validator: (value) => EmailValidator.validate(value!) ? null : 'Invalid email',
)
```

---

### **Authentication Screens**

#### `lib/screens/auth/login_screen.dart` 🔐
**Purpose:** User login interface

**Features:**
- Email and password input fields
- Form validation (EmailValidator)
- Login button with loading state
- Error message display
- Link to registration page
- "Forgot password?" support (optional)

**Flow:**
1. User enters email/password
2. Form validates input
3. Submit → calls `authProvider.login()`
4. Loading state shown
5. On success → Navigate to `/menu`
6. On error → Display error message

---

#### `lib/screens/auth/register_screen.dart` ✍️
**Purpose:** User account creation

**Features:**
- Email input with validation
- Username input with uniqueness check
- Password input with strength indicator
- Confirm password with match validation
- Real-time error feedback
- Link to login page

**Validation Steps:**
1. Email format validation
2. Username length (min 3 chars)
3. Username uniqueness check (Firestore query)
4. Password minimum length (6 chars)
5. Password confirmation match

---

#### `lib/screens/menu/menu_screen.dart` 📋
**Purpose:** Main menu after successful login

**Content:**
- Welcome message with username
- Navigation buttons:
  - Play Game → `/game`
  - View Leaderboard → `/leaderboard`
  - My Profile → `/profile`
- Logout button

---

#### `lib/screens/game/game_screen_placeholder.dart` 🎮
**Purpose:** Main game board interface

**Components:**
- 3x3 grid display with interactive cells
- Current player indicator
- Difficulty level selector (Easy/Medium/Hard)
- Move history
- Result dialog (when game ends)
- Play again / Back buttons

**Gameplay:**
1. Player selects difficulty
2. Player (X) makes first move (taps cell)
3. AI (O) responds automatically
4. Continue until win/draw
5. Show result with points earned
6. Update leaderboard

---

#### `lib/screens/leaderboard/leaderboard_screen_placeholder.dart` 🏅
**Purpose:** Real-time leaderboard display

**Display:**
- Rank (1-10)
- Username
- Total games
- Total wins
- Win percentage
- Highest score
- Current user highlighted

**Real-time Updates:**
- Leaderboard updates immediately after each game
- Data from Firestore stream

---

#### `lib/screens/profile/profile_screen_placeholder.dart` 👤
**Purpose:** User profile and career statistics

**Display:**
- Username and email
- Account creation date
- Career statistics:
  - Total games played
  - Total wins
  - Total losses
  - Draw count
  - Win percentage
  - Highest score
  - Average score

---

## 🚀 Complete Setup Instructions

### **Prerequisites**

Before starting, ensure you have:

✓ **Flutter 3.10+** - [Download Flutter](https://flutter.dev/docs/get-started/install)  
✓ **Dart 3.0+** - (Comes with Flutter)  
✓ **Android Studio** - [Download](https://developer.android.com/studio)  
✓ **Google Account** - For Firebase Console access  
✓ **Git** - [Download](https://git-scm.com/)  
✓ **Text Editor** - VS Code or Android Studio  

---

### **Step 1: Clone or Download Project**

```bash
# Clone from Git
git clone https://github.com/yourrepo/tictactoe_fp_tekber.git
cd tictactoe_fp_tekber

# OR download ZIP and extract
# Then navigate to folder
cd tictactoe_fp_tekber
```

---

### **Step 2: Install Flutter Dependencies**

```bash
# Install all package dependencies
flutter pub get

# Clean previous builds (recommended)
flutter clean
flutter pub get
```

**Installed Packages:**
- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Database
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `audioplayers` - Sound effects
- `email_validator` - Email validation

---

### **Step 3: Firebase Project Setup**

#### 3.1 Create Firebase Project

1. Open [Firebase Console](https://console.firebase.google.com)
2. Click **"Create a project"**
3. Enter project name: `tictactoe_fp_tekber`
4. Accept Firebase terms
5. Click **"Create project"** and wait for completion

#### 3.2 Add Android App to Firebase

1. In Firebase Console, click **"Add app"** → Select **Android**
2. Enter package name: `com.example.tictactoe_fp_tekber`
3. Click **"Register app"**
4. Download `google-services.json`
5. Place file in: `android/app/google-services.json`
6. Click **"Next"** through the setup steps
7. Click **"Continue to console"**

✅ **Verify:** Open `android/app/build.gradle.kts` - should contain:
```kotlin
id("com.google.gms.google-services")
```

#### 3.3 Enable Authentication

1. Go to **Authentication** section (left menu)
2. Click **"Get started"**
3. Under "Sign-in method", click **"Email/Password"**
4. Toggle **"Enable"** switch
5. Click **"Save"**

✅ **Verify:** Email/Password method shows "Enabled" status

#### 3.4 Create Firestore Database

1. Go to **Firestore Database** section
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Click **"Create"**
5. Choose region: **"us-central1"** (or nearest)
6. Click **"Enable"**

✅ **Verify:** You see empty Firestore console

#### 3.5 Create Firestore Collections

**Collection 1: `users`**

1. In Firestore, click **"Create collection"**
2. Name: `users`
3. Click **"Auto ID"** for first document
4. Add fields:
   ```
   uid: (string) "auto-generated"
   email: (string) "user@example.com"
   username: (string) "username"
   totalGamesPlayed: (number) 0
   totalWins: (number) 0
   highestScore: (number) 0
   createdAt: (timestamp) current date
   ```
5. Click **"Save"**

**Collection 2: `game_results`**

1. Click **"Create collection"**
2. Name: `game_results`
3. Click **"Auto ID"** for first document
4. Add fields:
   ```
   userId: (string) "user-id-123"
   result: (string) "win" | "draw" | "loss"
   pointsEarned: (number) 10
   opponent: (string) "easy" | "medium" | "hard"
   gameDate: (timestamp) current date
   ```
5. Click **"Save"**

✅ **Verify:** Both collections appear in Firestore console

---

### **Step 4: Add Audio Files**

1. Create folder: `assets/sounds/`
2. Place these sound files (as MP3):
   - `tap.mp3` - Board tap sound (~200ms)
   - `win.mp3` - Victory sound (~500ms)
   - `lose.mp3` - Loss sound (~500ms)

**Free Sound Resources:**
- [Freesound.org](https://freesound.org) - Creative Commons sounds
- [Zapsplat.com](https://www.zapsplat.com) - Free sound effects
- [Pixabay.com/sounds](https://pixabay.com/sound-effects) - Royalty-free

✅ **Verify:** Files exist at `assets/sounds/tap.mp3`, `assets/sounds/win.mp3`, `assets/sounds/lose.mp3`

---

### **Step 5: Configure Android Emulator**

1. Open **Android Studio**
2. Click **"Device Manager"** (bottom right)
3. Click **"Create device"**
4. Select device (e.g., "Pixel 6")
5. Click **"Next"**
6. Select API level 33+ (e.g., "UpsideDownCake")
7. Click **"Next"** → **"Finish"**
8. Click **"Play"** button to launch emulator
9. Wait for emulator to fully load (~1 minute)

---

### **Step 6: Run the Application**

```bash
# Check connected devices
flutter devices

# Run on Android emulator
flutter run -d emulator-5554

# OR run on physical Android device (USB debugging enabled)
flutter run

# OR run on web (for testing)
flutter run -d web
```

**Expected Output:**
```
Launching lib/main.dart on emulator-5554 in debug mode...
Building flutter app in debug mode...
✓ Built build/app/outputs/apk/debug/app-debug.apk (...)
Installing and launching...
... app launches on emulator
```

---

### **Step 7: Test the Application**

#### Authentication Flow
1. ✅ **Register:** Create new account with unique username
2. ✅ **Login:** Sign in with registered credentials
3. ✅ **Validation:** Enter invalid email/password → See error messages
4. ✅ **Logout:** Click logout → Return to login screen

#### Navigation Flow
1. ✅ **Auth Guard:** Try opening app → Auto-redirect to login
2. ✅ **After Login:** Navigate to Menu → Game → Leaderboard → Profile → Menu
3. ✅ **Back Button:** Test back navigation on all screens

#### Game Flow
1. ✅ **Game Start:** Select difficulty → See empty 3x3 board
2. ✅ **Player Move:** Tap cell → X appears + audio plays
3. ✅ **AI Move:** Tap cell → AI (O) automatically responds
4. ✅ **Win Condition:** Get 3 in a row → Victory screen appears
5. ✅ **Sound Effects:** Verify tap/win/lose sounds play
6. ✅ **Leaderboard:** After game → Check real-time update

#### Database Verification
1. ✅ **Firebase Console:** Go to Firestore
2. ✅ **Users Collection:** See new user document
3. ✅ **Game Results:** See game result records
4. ✅ **Leaderboard:** Verify user appears with correct stats

---

## 🎯 Game Scoring System

| Outcome | Points | Notes |
|---------|--------|-------|
| **Win** | 10 | Three in a row |
| **Draw** | 5 | Board full, no winner |
| **Loss** | 0 | AI gets three in a row |

**Leaderboard Ranking:**
- Primary: Highest score (total points)
- Secondary: Most wins
- Tertiary: Most games played

**Example Progression:**
```
Game 1: Win (10 pts)      → Total: 10 pts, 1 win
Game 2: Draw (5 pts)      → Total: 15 pts, 1 win, 1 draw
Game 3: Loss (0 pts)      → Total: 15 pts, 1 win, 1 loss
Game 4: Win (10 pts)      → Total: 25 pts, 2 wins
```

---

## 📊 Features Status

### **✅ Fully Implemented**

- ✅ User Registration with unique username
- ✅ User Login with validation
- ✅ Email and password validation
- ✅ Logout functionality
- ✅ Firebase Authentication
- ✅ Firestore database integration
- ✅ User profile persistence
- ✅ Navigation routing with auth guard
- ✅ Material Design 3 UI
- ✅ Sound effects (tap, win, lose)
- ✅ Game board initialization
- ✅ Move validation
- ✅ Win/draw detection
- ✅ User interface screens (Login, Register, Menu, Game, Leaderboard, Profile)

### **🔄 In Development** (Zeldano's Tasks)

- 🔄 Complete game UI (3x3 grid interaction)
- 🔄 AI opponent implementation (Easy/Medium/Hard)
- 🔄 Game state management (Game Provider)
- 🔄 Result saving to Firestore
- 🔄 Leaderboard real-time updates

### **📋 Future Enhancements**

- 📋 Multiplayer mode (two human players)
- 📋 Game statistics graphs
- 📋 User achievements/badges
- 📋 Push notifications
- 📋 Offline mode with sync
- 📋 Game replay feature
- 📋 Customizable themes
- 📋 Chat/messaging system

---

## 🧪 Testing Checklist

Before final submission, verify all items:

**Authentication:**
- [ ] Registration creates new user in Firebase
- [ ] Unique username validation works
- [ ] Login authenticates correctly
- [ ] Invalid credentials show error messages
- [ ] Logout clears authentication state

**Navigation:**
- [ ] Unauthenticated users redirected to login
- [ ] All screen transitions work
- [ ] Back button navigates correctly
- [ ] Deep linking works (if implemented)

**Game Mechanics:**
- [ ] Board displays 3x3 grid
- [ ] Player can tap cells
- [ ] AI responds to player moves
- [ ] Win condition detected (3 in a row)
- [ ] Draw condition detected (full board)
- [ ] Game can be reset for new game

**Audio:**
- [ ] Tap sound plays on valid move
- [ ] Win sound plays on player victory
- [ ] Lose sound plays on AI victory
- [ ] Volume controls work
- [ ] No crashes due to missing audio files

**Database:**
- [ ] User documents created in Firestore
- [ ] Game results saved after each game
- [ ] User statistics update correctly
- [ ] Leaderboard displays top players
- [ ] Profile shows correct user stats
- [ ] Real-time updates work

**UI/UX:**
- [ ] Material Design 3 theme applied
- [ ] Buttons responsive to taps
- [ ] Form validation shows helpful messages
- [ ] Loading states displayed
- [ ] Error states handled gracefully
- [ ] App doesn't crash on edge cases

**Performance:**
- [ ] App starts within 2 seconds
- [ ] Game responds immediately to taps
- [ ] Leaderboard loads in < 1 second
- [ ] No memory leaks on screen transitions
- [ ] Audio plays without lag

---

## 🔧 Development Commands Reference

```bash
# Project Setup
flutter pub get                          # Install dependencies
flutter clean                            # Clean build artifacts
flutter pub upgrade                      # Upgrade packages

# Running
flutter run                              # Run on default device
flutter run -d emulator-5554            # Run on specific device
flutter run -d web                      # Run on web browser
flutter run --release                   # Run in release mode

# Code Quality
flutter analyze                          # Check for code issues
flutter format lib/                     # Format code
flutter test                            # Run unit tests

# Building
flutter build apk --release             # Build Android APK
flutter build ios --release             # Build iOS app
flutter build web --release             # Build web version

# Debugging
flutter logs                             # View app logs
flutter devices                          # List connected devices
flutter upgrade                          # Upgrade Flutter SDK
```

---

## 📚 Additional Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed step-by-step setup with screenshots
- **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** - Firebase configuration and Firestore schema details
- **[Flutter Docs](https://docs.flutter.dev/)** - Official Flutter documentation
- **[Firebase Console](https://console.firebase.google.com)** - Firebase project management

---

## 🐛 Troubleshooting Guide

### **"There is nothing to pop" Navigation Error**

**Symptom:** App crashes when tapping back button
```
GoError: There is nothing to pop
```

**Solution:**
- Use `context.go('/route')` for absolute navigation (not `context.pop()`)
- Ensure navigation uses `context.push()` for forward and `context.go()` for backward
- Wrap screens with `PopScope(canPop: false)` to handle hardware back button

---

### **Audio Not Playing on Android**

**Symptom:** No sound effects during gameplay

**Checklist:**
1. ✓ Sound files exist: `assets/sounds/tap.mp3`, `win.mp3`, `lose.mp3`
2. ✓ `pubspec.yaml` contains: `assets: - assets/sounds/`
3. ✓ Run `flutter clean` then `flutter pub get`
4. ✓ Device volume is NOT muted
5. ✓ Check Firebase console logs for errors

---

### **Firebase Connection Failed**

**Symptom:** Authentication fails, database queries return errors

**Checklist:**
1. ✓ `google-services.json` is in `android/app/`
2. ✓ Package name matches Firebase project
3. ✓ Firebase project is created and enabled
4. ✓ Authentication (Email/Password) is enabled
5. ✓ Firestore database is created
6. ✓ Internet connection is active

---

### **Gradle Build Fails**

**Symptom:** 
```
Error resolving plugin 'com.google.gms.google-services'
```

**Solution:**
- Ensure `android/app/build.gradle.kts` has: `id("com.google.gms.google-services")`
- Don't specify version in plugin ID (let Gradle manage it)
- Run `flutter clean` and rebuild

---

### **Emulator Won't Start**

**Symptom:** Emulator not showing in `flutter devices`

**Solution:**
1. Open Android Studio
2. Go to Device Manager (bottom right)
3. Click Play button on desired device
4. Wait 1-2 minutes for emulator to fully load
5. Run `flutter run` again

---

### **Firestore Collections Not Appearing**

**Symptom:** Created collections don't show in Firestore console

**Solution:**
- Add first document manually to create collection
- Check Firestore security rules (test mode allows all)
- Ensure Firestore database is created (not just project)
- Verify users have permission to write to Firestore

---

## 📞 Support & Contacts

**Team Members:**

| Name | Role | Email |
|------|------|-------|
| Hafizhan Yusra Sulistyo | Auth & Navigation | hafizhan@student.itb.ac.id |
| Zeldano Shan Oeffie | Game Logic & AI | zeldano@student.itb.ac.id |

**Course Instructor:** [Instructor Name]  
**Course:** Emerging Technology (IF4071)  
**Assignment:** Tic Tac Toe Game Application

---

## 📅 Important Dates

| Date | Event |
|------|-------|
| December 19, 2025, 23:55 WIB | **Final Submission Deadline** |
| Before 23:55 WIB | Last commit to Git repository |
| After deadline | YouTube video demonstration (optional) |

---

## 📄 License & Disclaimer

This project is submitted as a course assignment for the Emerging Technology class at Institut Teknologi Bandung (ITB). All code is original work of the team members unless otherwise stated.

**Note:** This is a development version. For production use, additional security hardening and testing is recommended.

---

## ✨ Acknowledgments

- Flutter & Dart communities
- Firebase documentation
- Material Design 3 guidelines
- Open-source libraries (see `pubspec.yaml`)

---

**Last Updated:** December 19, 2025  
**Version:** 1.0.0  
**Status:** Ready for Submission
