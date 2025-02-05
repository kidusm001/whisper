class MembershipTierModel {
  final String id;
  final String creatorId;
  final String name;
  final String description;
  final double price;
  final List<String> benefits;

  MembershipTierModel({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.description,
    required this.price,
    required this.benefits,
  });

  factory MembershipTierModel.fromJson(Map<String, dynamic> json) {
    return MembershipTierModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'name': name,
      'description': description,
      'price': price,
      'benefits': benefits,
    };
  }
}
