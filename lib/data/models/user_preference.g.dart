// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferenceImpl _$$UserPreferenceImplFromJson(Map<String, dynamic> json) =>
    _$UserPreferenceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      key: json['key'] as String,
      value: json['value'] as String,
      type: json['type'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isSystem: json['isSystem'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserPreferenceImplToJson(
        _$UserPreferenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'category': instance.category,
      'description': instance.description,
      'metadata': instance.metadata,
      'isSystem': instance.isSystem,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
