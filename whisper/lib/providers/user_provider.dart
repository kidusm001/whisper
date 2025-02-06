import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

part 'user_provider.g.dart';

@riverpod
Stream<AppUser?> user(Ref ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges.asyncMap((firebaseUser) async {
    if (firebaseUser == null) return null;
    return ref.read(userRepositoryProvider).getUser(firebaseUser.uid);
  });
}
