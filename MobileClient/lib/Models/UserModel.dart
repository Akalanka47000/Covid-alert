import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'UserModel.g.dart';
@JsonSerializable()
class UserModel{
  final String id;
  final String userName;
  final String email;
  final String role;
  final String photo;
  final String preferredCategory;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  UserModel(this.id,this.userName,this.email,this.role, this.photo, this.preferredCategory, this.likes, this.dislikes);


  factory UserModel.fromJson(Map<String,dynamic>json)
  =>_$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}