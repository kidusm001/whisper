// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      creatorId: json['creatorId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      tierId: json['tierId'] as String?,
      stripePaymentId: json['stripePaymentId'] as String?,
      createdAt:
          TransactionModel._timestampFromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'creatorId': instance.creatorId,
      'type': instance.type,
      'amount': instance.amount,
      'status': instance.status,
      'tierId': instance.tierId,
      'stripePaymentId': instance.stripePaymentId,
      'createdAt': TransactionModel._timestampToJson(instance.createdAt),
    };
