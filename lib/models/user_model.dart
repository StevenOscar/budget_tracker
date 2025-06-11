// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  int? id;
  String name;
  String username;
  String? password;
  String phoneNumber;
  int monthlyBudget;

  UserModel({
    this.id,
    required this.name,
    required this.username,
    this.password,
    required this.phoneNumber,
    required this.monthlyBudget,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'password': password,
      'phone_number': phoneNumber,
      'monthly_budget': monthlyBudget,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      phoneNumber: map['phone_number'] as String,
      monthlyBudget: map['monthly_budget'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
