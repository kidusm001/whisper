// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tierConfigsHash() => r'a6f111c002814efa59da5421276f2a0db100eb5c';

/// See also [tierConfigs].
@ProviderFor(tierConfigs)
final tierConfigsProvider =
    AutoDisposeStreamProvider<List<TierConfig>>.internal(
  tierConfigs,
  name: r'tierConfigsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tierConfigsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TierConfigsRef = AutoDisposeStreamProviderRef<List<TierConfig>>;
String _$tierConfigByTypeHash() => r'2e40de42cc705e4627671fc2243da47590fbe8a2';

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

/// See also [tierConfigByType].
@ProviderFor(tierConfigByType)
const tierConfigByTypeProvider = TierConfigByTypeFamily();

/// See also [tierConfigByType].
class TierConfigByTypeFamily extends Family<AsyncValue<TierConfig>> {
  /// See also [tierConfigByType].
  const TierConfigByTypeFamily();

  /// See also [tierConfigByType].
  TierConfigByTypeProvider call(
    SubscriptionTier tier,
  ) {
    return TierConfigByTypeProvider(
      tier,
    );
  }

  @override
  TierConfigByTypeProvider getProviderOverride(
    covariant TierConfigByTypeProvider provider,
  ) {
    return call(
      provider.tier,
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
  String? get name => r'tierConfigByTypeProvider';
}

/// See also [tierConfigByType].
class TierConfigByTypeProvider extends AutoDisposeFutureProvider<TierConfig> {
  /// See also [tierConfigByType].
  TierConfigByTypeProvider(
    SubscriptionTier tier,
  ) : this._internal(
          (ref) => tierConfigByType(
            ref as TierConfigByTypeRef,
            tier,
          ),
          from: tierConfigByTypeProvider,
          name: r'tierConfigByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tierConfigByTypeHash,
          dependencies: TierConfigByTypeFamily._dependencies,
          allTransitiveDependencies:
              TierConfigByTypeFamily._allTransitiveDependencies,
          tier: tier,
        );

  TierConfigByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tier,
  }) : super.internal();

  final SubscriptionTier tier;

  @override
  Override overrideWith(
    FutureOr<TierConfig> Function(TierConfigByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TierConfigByTypeProvider._internal(
        (ref) => create(ref as TierConfigByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tier: tier,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TierConfig> createElement() {
    return _TierConfigByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TierConfigByTypeProvider && other.tier == tier;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tier.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TierConfigByTypeRef on AutoDisposeFutureProviderRef<TierConfig> {
  /// The parameter `tier` of this provider.
  SubscriptionTier get tier;
}

class _TierConfigByTypeProviderElement
    extends AutoDisposeFutureProviderElement<TierConfig>
    with TierConfigByTypeRef {
  _TierConfigByTypeProviderElement(super.provider);

  @override
  SubscriptionTier get tier => (origin as TierConfigByTypeProvider).tier;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
