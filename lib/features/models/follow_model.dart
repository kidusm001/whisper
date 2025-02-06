// File: follow_model.dart
// Description: Model for user follow relationships

class FollowModel {
  final String userId;
  final String followUserId;
  final DateTime timestamp;

  FollowModel({
    required this.userId,
    required this.followUserId,
    required this.timestamp,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      userId: json['user_id'],
      followUserId: json['follow_user_id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'follow_user_id': followUserId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}