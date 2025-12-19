class GameResultModel {
  final String? id;
  final String userId;
  final String result; // 'win', 'draw', 'loss'
  final int pointsEarned; // 10 for win, 5 for draw, 0 for loss
  final String opponent; // 'AI Easy', 'AI Medium', 'AI Hard'
  final DateTime gameDate;

  GameResultModel({
    this.id,
    required this.userId,
    required this.result,
    required this.pointsEarned,
    required this.opponent,
    required this.gameDate,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'result': result,
      'pointsEarned': pointsEarned,
      'opponent': opponent,
      'gameDate': gameDate.toIso8601String(),
    };
  }

  /// Create from Firestore document
  factory GameResultModel.fromMap(Map<String, dynamic> map, String docId) {
    return GameResultModel(
      id: docId,
      userId: map['userId'] as String,
      result: map['result'] as String,
      pointsEarned: map['pointsEarned'] as int,
      opponent: map['opponent'] as String,
      gameDate: DateTime.parse(map['gameDate'] as String),
    );
  }

  @override
  String toString() {
    return 'GameResultModel(id: $id, userId: $userId, result: $result, pointsEarned: $pointsEarned, opponent: $opponent)';
  }
}
