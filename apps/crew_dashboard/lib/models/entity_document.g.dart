// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityDocument _$EntityDocumentFromJson(Map<String, dynamic> json) =>
    EntityDocument(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
      dateTimeUploaded: json['dateTimeUploaded'] as String? ?? '',
      size: json['size'] as String? ?? '',
      type: json['type'] as String? ?? '',
      fileExtension: json['fileExtension'] as String? ?? '',
      fileThumbnailUrl: json['fileThumbnailUrl'] as String? ?? '',
    );

Map<String, dynamic> _$EntityDocumentToJson(EntityDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'fileUrl': instance.fileUrl,
      'dateTimeUploaded': instance.dateTimeUploaded,
      'size': instance.size,
      'type': instance.type,
      'fileExtension': instance.fileExtension,
      'fileThumbnailUrl': instance.fileThumbnailUrl,
    };
