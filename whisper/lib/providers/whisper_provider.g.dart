// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationMessagesHash() =>
    r'e37b70a3a3c06a42182773bd71eded8389a1b97d';

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

/// See also [conversationMessages].
@ProviderFor(conversationMessages)
const conversationMessagesProvider = ConversationMessagesFamily();

/// See also [conversationMessages].
class ConversationMessagesFamily
    extends Family<AsyncValue<List<WhisperMessage>>> {
  /// See also [conversationMessages].
  const ConversationMessagesFamily();

  /// See also [conversationMessages].
  ConversationMessagesProvider call({
    required String currentUserId,
    required String otherUserId,
  }) {
    return ConversationMessagesProvider(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );
  }

  @override
  ConversationMessagesProvider getProviderOverride(
    covariant ConversationMessagesProvider provider,
  ) {
    return call(
      currentUserId: provider.currentUserId,
      otherUserId: provider.otherUserId,
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
  String? get name => r'conversationMessagesProvider';
}

/// See also [conversationMessages].
class ConversationMessagesProvider
    extends AutoDisposeStreamProvider<List<WhisperMessage>> {
  /// See also [conversationMessages].
  ConversationMessagesProvider({
    required String currentUserId,
    required String otherUserId,
  }) : this._internal(
          (ref) => conversationMessages(
            ref as ConversationMessagesRef,
            currentUserId: currentUserId,
            otherUserId: otherUserId,
          ),
          from: conversationMessagesProvider,
          name: r'conversationMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMessagesHash,
          dependencies: ConversationMessagesFamily._dependencies,
          allTransitiveDependencies:
              ConversationMessagesFamily._allTransitiveDependencies,
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        );

  ConversationMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentUserId,
    required this.otherUserId,
  }) : super.internal();

  final String currentUserId;
  final String otherUserId;

  @override
  Override overrideWith(
    Stream<List<WhisperMessage>> Function(ConversationMessagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationMessagesProvider._internal(
        (ref) => create(ref as ConversationMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<WhisperMessage>> createElement() {
    return _ConversationMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMessagesProvider &&
        other.currentUserId == currentUserId &&
        other.otherUserId == otherUserId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentUserId.hashCode);
    hash = _SystemHash.combine(hash, otherUserId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationMessagesRef
    on AutoDisposeStreamProviderRef<List<WhisperMessage>> {
  /// The parameter `currentUserId` of this provider.
  String get currentUserId;

  /// The parameter `otherUserId` of this provider.
  String get otherUserId;
}

class _ConversationMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<WhisperMessage>>
    with ConversationMessagesRef {
  _ConversationMessagesProviderElement(super.provider);

  @override
  String get currentUserId =>
      (origin as ConversationMessagesProvider).currentUserId;
  @override
  String get otherUserId =>
      (origin as ConversationMessagesProvider).otherUserId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
