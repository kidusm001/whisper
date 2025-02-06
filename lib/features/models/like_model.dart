// File: like_model.dart
// Description: Model for post likes

class LikeModel {
  final String postId;
  final String userId;
  final DateTime timestamp;

  LikeModel({
    required this.postId,
    required this.userId,
    required this.timestamp,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      postId: json['post_id'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}