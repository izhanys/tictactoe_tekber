import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final int totalGamesPlayed;
  final int totalWins;
  final int highestScore;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.totalGamesPlayed = 0,
    this.totalWins = 0,
    this.highestScore = 0,
    required this.createdAt,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'totalGamesPlayed': totalGamesPlayed,
      'totalWins': totalWins,
      'highestScore': highestScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Handle createdAt - can be Timestamp from Firestore or String
    DateTime createdAtDate;
    final createdAtValue = map['createdAt'];
    
    if (createdAtValue is Timestamp) {
      // Firestore Timestamp
      createdAtDate = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      // ISO String format
      createdAtDate = DateTime.parse(createdAtValue);
    } else {
      // Fallback to current time
      createdAtDate = DateTime.now();
    }

    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      totalGamesPlayed: map['totalGamesPlayed'] as int? ?? 0,
      totalWins: map['totalWins'] as int? ?? 0,
      highestScore: map['highestScore'] as int? ?? 0,
      createdAt: createdAtDate,
    );
  }

  /// Copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? totalGamesPlayed,
    int? totalWins,
    int? highestScore,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalWins: totalWins ?? this.totalWins,
      highestScore: highestScore ?? this.highestScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, highestScore: $highestScore)';
  }
}
