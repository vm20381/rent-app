// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityItem _$EntityItemFromJson(Map<String, dynamic> json) => EntityItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastChecked: json['lastChecked'] as String? ?? '',
      installer: json['installer'] as String? ?? '',
      purchaseInfo: json['purchaseInfo'] as String? ?? '',
      specifications: json['specifications'] as String? ?? '',
      warranty: json['warranty'] as String? ?? '',
      billOfMaterials: json['billOfMaterials'] as String? ?? '',
      taskComplete: (json['taskComplete'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$EntityItemToJson(EntityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'lastChecked': instance.lastChecked,
      'installer': instance.installer,
      'purchaseInfo': instance.purchaseInfo,
      'specifications': instance.specifications,
      'warranty': instance.warranty,
      'billOfMaterials': instance.billOfMaterials,
      'taskComplete': instance.taskComplete,
    };
