import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/whisper_message.dart';

part 'whisper_repository.g.dart';

class WhisperRepository {
  final FirebaseFirestore _firestore;

  WhisperRepository(this._firestore);

  /// Sends a new message by writing it into the 'whispers' collection.
  Future<void> sendMessage(WhisperMessage message) async {
    await _firestore
        .collection('whispers')
        .doc(message.messageId)
        .set(message.toJson());
  }

  /// Fetch a single message by its ID.
  Future<WhisperMessage> getMessage(String messageId) async {
    final doc = await _firestore.collection('whispers').doc(messageId).get();
    return WhisperMessage.fromFirestore(doc);
  }

  /// Stream all messages between two users (in both directions).
  Stream<List<WhisperMessage>> watchMessages({
    required String userId,
    required String otherUserId,
  }) {
    return _firestore
        .collection('whispers')
        .where('senderId', whereIn: [userId, otherUserId])
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WhisperMessage.fromFirestore(doc))
            .where((message) =>
                (message.senderId == userId &&
                    message.recipientId == otherUserId) ||
                (message.senderId == otherUserId &&
                    message.recipientId == userId))
            .toList());
  }

  /// Mark a message as read.
  Future<void> markMessageAsRead(String messageId) async {
    await _firestore.collection('whispers').doc(messageId).update({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }
}

@riverpod
WhisperRepository whisperRepository(Ref ref) {
  return WhisperRepository(FirebaseFirestore.instance);
}
