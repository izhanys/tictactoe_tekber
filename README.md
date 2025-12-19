# Tic Tac Toe - Flutter Application

## 📱 Project Description

A modern Flutter-based Tic Tac Toe game with Firebase authentication, real-time leaderboard, AI opponent (3 difficulty levels), and sound effects. Players can register, login, play against AI, track statistics, and compete on a live leaderboard.

**Key Features:**
- User authentication (Firebase Auth)
- 3x3 game board with win/draw detection
- AI opponent (Easy/Medium/Hard)
- Real-time leaderboard (Firestore)
- Profile performance
- Sound effects (tap, win, lose)
- Material Design 3 UI
- Android platform support

---

## Team Members

| Name | ID | Role |
|------|-----|------|
| **Hafizhan Yusra Sulistyo** | 5026231060 | **Authentication & Navigation** - User registration/login, app routing, sound effects |
| **Zeldano Shan Oeffie** | 5026231118 | **Game Logic & AI** - Game engine, AI algorithms, game state management |

---

### **Step 1: Clone or Download Project**

```bash
# Clone from Git
git clone https://github.com/izhanys/tictactoe_tekber.git
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

**Verify:** Open `android/app/build.gradle.kts` - should contain:
```kotlin
id("com.google.gms.google-services")
```

#### 3.3 Enable Authentication

1. Go to **Authentication** section (left menu)
2. Click **"Get started"**
3. Under "Sign-in method", click **"Email/Password"**
4. Toggle **"Enable"** switch
5. Click **"Save"**

**Verify:** Email/Password method shows "Enabled" status

#### 3.4 Create Firestore Database

1. Go to **Firestore Database** section
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development)
4. Click **"Create"**
5. Choose region: **"us-central1"** (or nearest)
6. Click **"Enable"**

**Verify:** You see empty Firestore console

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

**Verify:** Both collections appear in Firestore console

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
2. Click **"Device Manager"**
3. Click **"Create device"**
4. Select device (e.g., "medium screen")
5. Click **"Next"**
6. Select API level 36
7. Click **"Next"** → **"Finish"**
8. Click **"Play"** button to launch emulator
9. Wait for emulator to fully load

---

### **Step 6: Run the Application**

```bash
# Check connected devices
flutter devices

# Run on Android emulator
flutter run 

# OR run on physical Android device (USB debugging enabled)
flutter run
```

---

### **Step 7: Test the Application**

#### Authentication Flow
1. **Register:** Create new account with unique username
2. **Login:** Sign in with registered credentials
3. **Validation:** Enter invalid email/password → See error messages
4. **Logout:** Click logout → Return to login screen

#### Navigation Flow
1. **Auth Guard:** Try opening app → Auto-redirect to login
2. **After Login:** Navigate to Menu → Game → Leaderboard → Profile → Menu
3. **Back Button:** Test back navigation on all screens

#### Game Flow
1. **Game Start:** Select difficulty → See empty 3x3 board
2. **Player Move:** Tap cell → X appears + audio plays
3. **AI Move:** Tap cell → AI (O) automatically responds
4. **Win Condition:** Get 3 in a row → Victory screen appears
5. **Sound Effects:** Verify tap/win/lose sounds play
6. **Leaderboard:** After game → Check real-time update

#### Database Verification
1. **Firebase Console:** Go to Firestore
2. **Users Collection:** See new user document
3. **Game Results:** See game result records
4. **Leaderboard:** Verify user appears with correct stats

---

## Game Scoring System

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

## 🔧 Development Commands Reference

```bash
# Project Setup
flutter pub get                          # Install dependencies
flutter clean                            # Clean build artifacts
flutter pub upgrade                      # Upgrade packages

# Running
flutter run                              # Run on default device
flutter run -d emulator-5554            # Run on specific device
```