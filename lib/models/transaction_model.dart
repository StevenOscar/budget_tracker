// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/material.dart';

class TransactionModel {
  int? id;
  int userId;
  int amount;
  int type;
  String? note;
  String category;
  DateTime date;
  TimeOfDay time;

  TransactionModel({
    this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.note,
    required this.category,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'amount': amount,
      'type': type,
      'note': note,
      'category': category,
      'date': date.toIso8601String(),
      'time':
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      amount: map['amount'] as int,
      type: map['type'] as int,
      note: map['note'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
