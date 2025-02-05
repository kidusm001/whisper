class SubscriptionTier {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> benefits;
  final bool isPopular;
  final String level; // 'general', 'backstage', 'inner'

  const SubscriptionTier({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.benefits,
    this.isPopular = false,
    required this.level,
  });

  factory SubscriptionTier.fromJson(Map<String, dynamic> json) {
    return SubscriptionTier(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      benefits: List<String>.from(json['benefits'] ?? []),
      isPopular: json['isPopular'] as bool? ?? false,
      level: json['level'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'benefits': benefits,
      'isPopular': isPopular,
      'level': level,
    };
  }

  static List<SubscriptionTier> getDefaultTiers() {
    return [
      const SubscriptionTier(
        id: 'general',
        name: 'General Admission',
        description: 'Basic access to creator content',
        price: 5.0,
        benefits: [
          'Access to public posts',
          'Comment on content',
          'Join community discussions',
          'Monthly newsletter',
        ],
        level: 'general',
        isPopular: false,
      ),
      const SubscriptionTier(
        id: 'backstage',
        name: 'Backstage Pass',
        description: 'Enhanced access with exclusive content',
        price: 15.0,
        benefits: [
          'All General Admission benefits',
          'Exclusive behind-the-scenes content',
          'Early access to new content',
          'Monthly Q&A sessions',
          'Exclusive merchandise discounts',
        ],
        level: 'backstage',
        isPopular: true,
      ),
      const SubscriptionTier(
        id: 'inner',
        name: 'Inner Circle',
        description: 'VIP access with personal interaction',
        price: 30.0,
        benefits: [
          'All Backstage Pass benefits',
          'Personal interaction with creator',
          'Private Discord channel access',
          'Custom content requests',
          'Exclusive live streams',
          'Priority support',
        ],
        level: 'inner',
        isPopular: false,
      ),
    ];
  }
}

class Subscription {
  final String id;
  final String userId;
  final String creatorId;
  final String tierId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String paymentMethod;
  final bool autoRenew;

  Subscription({
    required this.id,
    required this.userId,
    required this.creatorId,
    required this.tierId,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.paymentMethod,
    this.autoRenew = true,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      creatorId: json['creatorId'] as String,
      tierId: json['tierId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      paymentMethod: json['paymentMethod'] as String,
      autoRenew: json['autoRenew'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'creatorId': creatorId,
      'tierId': tierId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'paymentMethod': paymentMethod,
      'autoRenew': autoRenew,
    };
  }
}
