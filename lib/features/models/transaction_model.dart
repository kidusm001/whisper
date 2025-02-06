import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final String userId;
  final String creatorId;
  final String type;
  final double amount;
  final String status;
  final String? tierId;
  final String? stripePaymentId;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.creatorId,
    required this.type,
    required this.amount,
    required this.status,
    this.tierId,
    this.stripePaymentId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => 
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp _timestampToJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
} 