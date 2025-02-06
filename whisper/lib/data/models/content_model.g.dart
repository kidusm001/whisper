// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SecretContentImpl _$$SecretContentImplFromJson(Map<String, dynamic> json) =>
    _$SecretContentImpl(
      contentId: json['contentId'] as String,
      creatorId: json['creatorId'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      tierAccess: (json['tierAccess'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$SubscriptionTierEnumMap, k), e as bool),
      ),
      textContent: json['textContent'] as String?,
      encryptedBody: json['encryptedBody'] as String?,
      storagePath: json['storagePath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      mimeType: json['mimeType'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toDouble(),
      waveformData: json['waveformData'] as String?,
      watermarkSeed: json['watermarkSeed'] as String?,
      encryptionKey: json['encryptionKey'] as String?,
      publishDate: json['publishDate'] == null
          ? null
          : DateTime.parse(json['publishDate'] as String),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      isEphemeral: json['isEphemeral'] as bool? ?? false,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      unlockCount: (json['unlockCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      deepLink: json['deepLink'] as String?,
      dimensions: json['dimensions'] == null
          ? null
          : Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SecretContentImplToJson(_$SecretContentImpl instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'creatorId': instance.creatorId,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'tierAccess': instance.tierAccess
          .map((k, e) => MapEntry(_$SubscriptionTierEnumMap[k]!, e)),
      'textContent': instance.textContent,
      'encryptedBody': instance.encryptedBody,
      'storagePath': instance.storagePath,
      'thumbnailPath': instance.thumbnailPath,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'duration': instance.duration,
      'waveformData': instance.waveformData,
      'watermarkSeed': instance.watermarkSeed,
      'encryptionKey': instance.encryptionKey,
      'publishDate': instance.publishDate?.toIso8601String(),
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'isEphemeral': instance.isEphemeral,
      'isEncrypted': instance.isEncrypted,
      'viewCount': instance.viewCount,
      'unlockCount': instance.unlockCount,
      'shareCount': instance.shareCount,
      'deepLink': instance.deepLink,
      'dimensions': instance.dimensions?.toJson(),
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.audio: 'audio',
  ContentType.pdf: 'pdf',
  ContentType.ar: 'ar',
};

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.generalAdmission: 'generalAdmission',
  SubscriptionTier.backstagePass: 'backstagePass',
  SubscriptionTier.innerCircle: 'innerCircle',
};
