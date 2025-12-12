import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EventModel {
  EventModel({
    String? id,
    required this.title,
    required this.location,
    required this.notes,
    required this.dateTime,
    required this.colorValue,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String location;
  final String notes;
  final DateTime dateTime;
  final int colorValue;

  Color get color => Color(colorValue);

  EventModel copyWith({
    String? title,
    String? location,
    String? notes,
    DateTime? dateTime,
    int? colorValue,
  }) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      dateTime: DateTime.parse(json['dateTime'] as String),
      colorValue: json['colorValue'] as int? ?? Colors.teal.value,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'location': location,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(),
      'colorValue': colorValue,
    };
  }
}

