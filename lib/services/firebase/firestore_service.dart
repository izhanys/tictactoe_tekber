import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tictactoe_fp_tekber/models/game_result_model.dart';
import 'package:tictactoe_fp_tekber/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ============ USER OPERATIONS ============

  /// Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Get user failed: $e');
    }
  }

  /// Update user stats (after game)
  Future<void> updateUserStats({
    required String uid,
    required int gamesPlayed,
    required int wins,
    required int highestScore,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'totalGamesPlayed': gamesPlayed,
        'totalWins': wins,
        'highestScore': highestScore,
      });
    } catch (e) {
      throw Exception('Update user stats failed: $e');
    }
  }

  // ============ GAME RESULT OPERATIONS ============

  /// Save game result
  Future<String> saveGameResult(GameResultModel result) async {
    try {
      final docRef = await _firestore.collection('game_results').add(result.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Save game result failed: $e');
    }
  }

  /// Get all game results for a user
  Future<List<GameResultModel>> getUserGameResults(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('game_results')
          .where('userId', isEqualTo: userId)
          .orderBy('gameDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => GameResultModel.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      throw Exception('Get user game results failed: $e');
    }
  }

  /// Stream user game results (real-time)
  Stream<List<GameResultModel>> streamUserGameResults(String userId) {
    try {
      return _firestore
          .collection('game_results')
          .where('userId', isEqualTo: userId)
          .orderBy('gameDate', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => GameResultModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ))
              .toList());
    } catch (e) {
      throw Exception('Stream user game results failed: $e');
    }
  }

  // ============ LEADERBOARD OPERATIONS ============

  /// Get top leaderboard (highest score)
  Future<List<UserModel>> getTopLeaderboard({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('highestScore', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Get top leaderboard failed: $e');
    }
  }

  /// Stream top leaderboard (real-time)
  Stream<List<UserModel>> streamTopLeaderboard({int limit = 10}) {
    try {
      return _firestore
          .collection('users')
          .orderBy('highestScore', descending: true)
          .limit(limit)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw Exception('Stream top leaderboard failed: $e');
    }
  }

  /// Get user rank based on highest score
  Future<int?> getUserRank(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;

      final userScore = (userDoc.data() as Map<String, dynamic>)['highestScore'] as int;

      final higherScoresSnapshot = await _firestore
          .collection('users')
          .where('highestScore', isGreaterThan: userScore)
          .get();

      return higherScoresSnapshot.docs.length + 1; // rank starts from 1
    } catch (e) {
      throw Exception('Get user rank failed: $e');
    }
  }

  /// Get leaderboard by total wins
  Future<List<UserModel>> getLeaderboardByWins({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('totalWins', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Get leaderboard by wins failed: $e');
    }
  }

  /// Stream leaderboard by total wins (real-time)
  Stream<List<UserModel>> streamLeaderboardByWins({int limit = 10}) {
    try {
      return _firestore
          .collection('users')
          .orderBy('totalWins', descending: true)
          .limit(limit)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw Exception('Stream leaderboard by wins failed: $e');
    }
  }
}
