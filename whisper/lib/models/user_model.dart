class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final String subscriptionTier; // 'none', 'general', 'backstage', 'inner'
  final DateTime? subscriptionExpiry;
  final List<String> following; // List of creator UIDs being followed
  final bool isCreator;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.subscriptionTier = 'none',
    this.subscriptionExpiry,
    this.following = const [],
    this.isCreator = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      subscriptionTier: json['subscriptionTier'] as String? ?? 'none',
      subscriptionExpiry: json['subscriptionExpiry'] != null
          ? DateTime.parse(json['subscriptionExpiry'] as String)
          : null,
      following: List<String>.from(json['following'] ?? []),
      isCreator: json['isCreator'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'subscriptionTier': subscriptionTier,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
      'following': following,
      'isCreator': isCreator,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? bio,
    String? subscriptionTier,
    DateTime? subscriptionExpiry,
    List<String>? following,
    bool? isCreator,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      following: following ?? this.following,
      isCreator: isCreator ?? this.isCreator,
    );
  }
}
