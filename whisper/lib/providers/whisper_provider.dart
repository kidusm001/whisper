import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/whisper_message.dart';
import '../../../data/repositories/whisper_repository.dart';

part 'whisper_provider.g.dart';

@riverpod
Stream<List<WhisperMessage>> conversationMessages(
  Ref ref, {
  required String currentUserId,
  required String otherUserId,
}) {
  final repo = ref.watch(whisperRepositoryProvider);
  return repo.watchMessages(
    userId: currentUserId,
    otherUserId: otherUserId,
  );
}
