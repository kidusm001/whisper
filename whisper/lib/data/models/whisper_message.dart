import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_message.freezed.dart';
part 'whisper_message.g.dart';

/// Define an enum to differentiate message types.
enum MessageType { text, image, video, file }

@freezed
class WhisperMessage with _$WhisperMessage {
  @JsonSerializable(explicitToJson: true)
  const factory WhisperMessage({
    /// Unique identifier for the message.
    required String messageId,

    /// The sender's user ID.
    required String senderId,

    /// The recipient's user ID.
    required String recipientId,

    /// The text or description content.
    required String content,

    /// The time the message was sent.
    required DateTime sentAt,

    /// Optional time when the message was read.
    DateTime? readAt,

    /// Whether the message has been read.
    @Default(false) bool isRead,

    /// Type of the message.
    @Default(MessageType.text) MessageType messageType,

    /// Optional attachment URL (e.g. image, file).
    String? attachmentUrl,

    /// Optional timestamp when the message was last updated.
    DateTime? updatedAt,
  }) = _WhisperMessage;

  /// Factory to create a message from Firestore.
  factory WhisperMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WhisperMessage.fromJson({
      ...data,
      'messageId': doc.id,
      // Convert Firestore Timestamps to ISO8601 strings.
      'sentAt': (data['sentAt'] as Timestamp).toDate().toIso8601String(),
      'readAt': data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate().toIso8601String()
          : null,
      'updatedAt': data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
          : null,
    });
  }

  /// Factory for JSON deserialization.
  factory WhisperMessage.fromJson(Map<String, dynamic> json) =>
      _$WhisperMessageFromJson(json);
}
