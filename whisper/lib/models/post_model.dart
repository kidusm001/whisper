class PostModel {
  final String id;
  final String creatorId;
  final String creatorName;
  final String? creatorPhotoUrl;
  final String title;
  final String content;
  final String? imageUrl;
  final String accessTier; // 'general', 'backstage', 'inner'
  final DateTime createdAt;
  final List<String> likes;
  final List<String> comments;
  final Map<String, dynamic>? metadata;

  PostModel({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    this.creatorPhotoUrl,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.accessTier,
    required this.createdAt,
    this.likes = const [],
    this.comments = const [],
    this.metadata,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      creatorPhotoUrl: json['creatorPhotoUrl'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      accessTier: json['accessTier'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorPhotoUrl': creatorPhotoUrl,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'accessTier': accessTier,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'metadata': metadata,
    };
  }

  PostModel copyWith({
    String? id,
    String? creatorId,
    String? creatorName,
    String? creatorPhotoUrl,
    String? title,
    String? content,
    String? imageUrl,
    String? accessTier,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? comments,
    Map<String, dynamic>? metadata,
  }) {
    return PostModel(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorPhotoUrl: creatorPhotoUrl ?? this.creatorPhotoUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      accessTier: accessTier ?? this.accessTier,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      metadata: metadata ?? this.metadata,
    );
  }

  bool canAccess(String userTier) {
    final tiers = ['none', 'general', 'backstage', 'inner'];
    final userTierIndex = tiers.indexOf(userTier);
    final postTierIndex = tiers.indexOf(accessTier);
    return userTierIndex >= postTierIndex;
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 7) {
      return createdAt.toString().substring(0, 10);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
