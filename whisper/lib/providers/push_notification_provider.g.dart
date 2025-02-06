// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userNotificationsHash() => r'3999980f8afc3abb1b300c41fc4ff54ffbcda705';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userNotifications].
@ProviderFor(userNotifications)
const userNotificationsProvider = UserNotificationsFamily();

/// See also [userNotifications].
class UserNotificationsFamily
    extends Family<AsyncValue<List<PushNotification>>> {
  /// See also [userNotifications].
  const UserNotificationsFamily();

  /// See also [userNotifications].
  UserNotificationsProvider call({
    required String userId,
  }) {
    return UserNotificationsProvider(
      userId: userId,
    );
  }

  @override
  UserNotificationsProvider getProviderOverride(
    covariant UserNotificationsProvider provider,
  ) {
    return call(
      userId: provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userNotificationsProvider';
}

/// See also [userNotifications].
class UserNotificationsProvider
    extends AutoDisposeStreamProvider<List<PushNotification>> {
  /// See also [userNotifications].
  UserNotificationsProvider({
    required String userId,
  }) : this._internal(
          (ref) => userNotifications(
            ref as UserNotificationsRef,
            userId: userId,
          ),
          from: userNotificationsProvider,
          name: r'userNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userNotificationsHash,
          dependencies: UserNotificationsFamily._dependencies,
          allTransitiveDependencies:
              UserNotificationsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<PushNotification>> Function(UserNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserNotificationsProvider._internal(
        (ref) => create(ref as UserNotificationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PushNotification>> createElement() {
    return _UserNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotificationsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserNotificationsRef
    on AutoDisposeStreamProviderRef<List<PushNotification>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserNotificationsProviderElement
    extends AutoDisposeStreamProviderElement<List<PushNotification>>
    with UserNotificationsRef {
  _UserNotificationsProviderElement(super.provider);

  @override
  String get userId => (origin as UserNotificationsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
