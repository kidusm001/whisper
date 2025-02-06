import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'user_model.dart'; // Import SubscriptionTier (and other shared definitions)

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class SecretContent with _$SecretContent {
  const SecretContent._(); // Added for custom methods

  @JsonSerializable(explicitToJson: true)
  factory SecretContent({
    required String contentId,
    required String creatorId,
    required ContentType type,
    required Map<SubscriptionTier, bool> tierAccess,
    String? textContent,
    String? encryptedBody,
    String? storagePath,
    String? thumbnailPath,
    String? mimeType,
    int? fileSize,
    double? duration,
    String? waveformData,
    String? watermarkSeed,
    String? encryptionKey,
    DateTime? publishDate,
    DateTime? expirationDate,
    @Default(false) bool isEphemeral,
    @Default(false) bool isEncrypted,
    @Default(0) int viewCount,
    @Default(0) int unlockCount,
    @Default(0) int shareCount,
    String? deepLink,
    Dimensions? dimensions,
  }) = _SecretContent;

  factory SecretContent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SecretContent.fromJson(data).copyWith(contentId: doc.id);
  }

  factory SecretContent.fromJson(Map<String, dynamic> json) =>
      _$SecretContentFromJson(json);

  // Helper method to check tier access
  bool isAccessibleFor(SubscriptionTier tier) {
    return tierAccess[tier] ?? false;
  }

  // Encryption/Decryption methods
  String encryptContent(String plainText) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptionKey!)));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String? decryptContent(String cipherText) {
    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptionKey!)));
      return encrypter.decrypt(encrypt.Encrypted.fromBase64(cipherText),
          iv: iv);
    } catch (e) {
      return null;
    }
  }

  // Added getter to return the minimum required subscription tier for access.
  SubscriptionTier get minRequiredTier {
    final accessibleTiers =
        tierAccess.keys.where((tier) => tierAccess[tier] == true);
    if (accessibleTiers.isEmpty) {
      // Fallback to a default tier, adjust as needed.
      return SubscriptionTier.generalAdmission;
    }
    return accessibleTiers.reduce((a, b) => a.index < b.index ? a : b);
  }
}

enum ContentType {
  text,
  image,
  video,
  audio,
  pdf,
  ar,
}

@immutable
class Dimensions {
  final double width;
  final double height;

  const Dimensions(this.width, this.height);

  factory Dimensions.fromJson(Map<String, dynamic> json) =>
      Dimensions(json['width'], json['height']);

  Map<String, dynamic> toJson() => {'width': width, 'height': height};
}
