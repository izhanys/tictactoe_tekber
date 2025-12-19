# Firebase Setup Guide untuk Tic Tac Toe Project

## **Persiapan (sudah IJAN lakukan)**

### Folder Structure
```
lib/
├── models/
│   ├── user_model.dart          ✅
│   └── game_result_model.dart   ✅
├── services/
│   ├── firebase/
│   │   ├── auth_service.dart    ✅
│   │   └── firestore_service.dart ✅
│   └── game_engine/             ← Kamu buat
├── providers/
│   ├── auth_provider.dart       ✅
│   └── game_provider.dart       ← Kamu buat
└── screens/
    ├── auth/
    │   ├── login_screen.dart    ✅
    │   └── register_screen.dart ✅
    └── game/
        └── game_screen.dart     ← Kamu buat
```

---

## **Firebase Console Setup (sudah IJAN lakukan)**

### 1. Create Firebase Project
- [console.firebase.google.com](https://console.firebase.google.com)
- Create project baru atau select existing
- Enable billing (free tier cukup)

### 2. Setup Authentication
- **Build** → **Authentication**
- Klik **Get Started**
- Enable **Email/Password** provider

### 3. Setup Firestore Database
- **Build** → **Firestore Database**
- Klik **Create Database**
- Mode: **Start in test mode** (development)
- Region: pilih terdekat (e.g., `asia-southeast1`)

### 4. Create Collections & Firestore Rules
**Collections yang harus ada:**

#### Collection: `users`
```
Document ID: uid (dari Firebase Auth)
Fields:
  - uid (string)
  - email (string)
  - username (string)
  - totalGamesPlayed (number): 0
  - totalWins (number): 0
  - highestScore (number): 0
  - createdAt (timestamp)
```

#### Collection: `game_results`
```
Document ID: Auto-ID
Fields:
  - userId (string) - referensi ke uid dari users
  - result (string) - "win" / "draw" / "loss"
  - pointsEarned (number) - 10 win, 5 draw, 0 loss
  - opponent (string) - "AI Easy" / "AI Medium" / "AI Hard"
  - gameDate (timestamp)
```

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

### 5. Android Setup
- ⚙️ **Project Settings**
- Tab **Your apps** → pilih Android
- Download `google-services.json` → paste ke `android/app/`

---

## **Code yang Sudah Ada (untuk referensi Zeldano)**

### AuthService (`lib/services/firebase/auth_service.dart`)
```dart
// Untuk register user baru
Future<UserModel> register({
  required String email,
  required String password,
  required String username,
})

// Untuk login
Future<UserModel> login({
  required String email,
  required String password,
})

// Untuk logout
Future<void> logout()

// Check username exists
Future<bool> usernameExists(String username)
```

### FirestoreService (`lib/services/firebase/firestore_service.dart`)
```dart
// Save game result
Future<String> saveGameResult(GameResultModel result)

// Get user stats
Future<UserModel?> getUser(String uid)

// Update user stats (setelah game selesai)
Future<void> updateUserStats({
  required String uid,
  required int gamesPlayed,
  required int wins,
  required int highestScore,
})

// Stream top leaderboard (real-time)
Stream<List<UserModel>> streamTopLeaderboard({int limit = 10})

// Get user rank
Future<int?> getUserRank(String userId)
```

### AuthProvider (`lib/providers/auth_provider.dart`)
```dart
// Watch authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(...)

// Check if user authenticated
final isAuthenticatedProvider = Provider<bool>(...)
```

---

## **Untuk Zeldano: Implementasi Game Logic**

### 1. Game Engine Logic (`lib/services/game_engine/game_logic.dart`)

**Buat file baru dengan:**
- Board state (3x3 array, nilai: empty/X/O)
- Win detection logic
- Move validation
- Reset game

**Contoh struktur:**
```dart
class GameLogic {
  late List<List<String>> board; // 3x3
  String currentPlayer = 'X'; // X = player, O = AI
  
  void initializeBoard() { }
  bool isValidMove(int row, int col) { }
  void makeMove(int row, int col, String player) { }
  String? checkWinner() { }
  bool isBoardFull() { }
  void reset() { }
}
```

### 2. AI Player (`lib/services/game_engine/ai_player.dart`)

**Buat AI dengan 3 difficulty levels:**
- **Easy**: Random empty cell
- **Medium**: Basic minimax
- **Hard**: Full minimax dengan alpha-beta pruning

```dart
class AIPlayer {
  final GameLogic gameLogic;
  final String difficulty; // 'easy', 'medium', 'hard'
  
  Move getNextMove() { }
  int evaluate() { } // untuk minimax
}
```

### 3. Game Provider (`lib/providers/game_provider.dart`)

**Manage game state:**
```dart
class GameNotifier extends StateNotifier {
  GameLogic gameLogic;
  String difficulty = 'easy';
  GameResult? result;
  
  Future<void> startGame(String difficulty) { }
  Future<void> playerMove(int row, int col) { }
  Future<void> aiMove() { }
  Future<void> saveGameResult() { } // ke Firestore
}
```

### 4. Game Screen (`lib/screens/game/game_screen.dart`)

**UI Components:**
- 3x3 board buttons
- Difficulty selector (Easy/Medium/Hard)
- Reset button
- Result dialog (Win/Loss/Draw)
- Stats display

---

## **Flow: Game Start → Save Result**

1. **Player pilih difficulty** → `gameProvider.startGame(difficulty)`
2. **Player klik cell** → `gameProvider.playerMove(row, col)`
3. **AI move** → `gameProvider.aiMove()`
4. **Game selesai** → create `GameResultModel`
5. **Save ke Firestore** → `firestoreService.saveGameResult(result)`
6. **Update user stats** → `firestoreService.updateUserStats(...)`
7. **Leaderboard auto-update** (real-time via stream)

---

## **Testing Checklist**

- [ ] Register user baru → check di Firebase Console `/users` collection
- [ ] Login dengan user tadi
- [ ] Buat game vs AI Easy/Medium/Hard
- [ ] Kalahkan AI → check `/game_results` collection ada record baru
- [ ] Check user stats terupdate (`totalWins`, `highestScore`)
- [ ] Leaderboard real-time update

---

## **Environment Variable (firebase_options.dart)**

Sudah auto-generate pas jalankan `flutterfire configure`.
File ini ada di `lib/firebase_options.dart` (JANGAN edit manual).

---

## **Helpful Resources**

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Auth (Flutter)](https://firebase.google.com/docs/auth/flutter/start)
- [Riverpod State Management](https://riverpod.dev)
- [Flutter Go Router](https://pub.dev/packages/go_router)

---

## **Troubleshooting**

**Firestore rules error?**
- Check security rules di Console (copy-paste yang di atas)
- Pastikan user sudah login (`request.auth != null`)

**Data tidak tersimpan?**
- Check Console logs (`flutter run -v`)
- Verify collection names (case-sensitive)
- Check userId format (harus match dengan Firebase UID)

**Game result tidak muncul?**
- Verify `gameDate` field adalah timestamp (bukan string)
- Check `userId` field sama dengan current user UID

---

**GOOD LUCK! Hubungi IJAN kalau ada blocking issue 👍**
