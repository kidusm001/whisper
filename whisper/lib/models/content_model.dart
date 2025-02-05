class ContentModel {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String type;
  final String contentUrl;
  final DateTime postedAt;
  final List<String> allowedTiers;

  ContentModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.type,
    required this.contentUrl,
    required this.postedAt,
    required this.allowedTiers,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'image',
      contentUrl: json['contentUrl'] as String? ?? '',
      postedAt: DateTime.parse(json['postedAt'] as String),
      allowedTiers: List<String>.from(json['allowedTiers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'title': title,
      'description': description,
      'type': type,
      'contentUrl': contentUrl,
      'postedAt': postedAt.toIso8601String(),
      'allowedTiers': allowedTiers,
    };
  }
}
