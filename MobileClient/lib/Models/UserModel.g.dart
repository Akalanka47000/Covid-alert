// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json["_id"] as String,
    json["name"] as String,
    json["email"]as String,
    json["role"]as String,
    json["photo"]as String,
    json["category"]as String,
    json["likes"]as List<dynamic>,
    json["dislikes"]as List<dynamic>,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) =>
    <String, dynamic>{
      '_id': instance.id==null? "":instance.id,
      'name': instance.userName==null? "":instance.userName,
      'email': instance.email==null? "":instance.email,
      'role': instance.role==null? "":instance.role,
      'photo': instance.photo==null? "":instance.photo,
      'category': instance.preferredCategory==null? "":instance.preferredCategory,
      'likes': instance.likes==null? "":instance.likes,
      'dislikes': instance.dislikes==null? "":instance.dislikes,
    };
