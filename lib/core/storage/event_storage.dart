import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/events/models/event_model.dart';

class EventStorage {
  static const _eventsKey = 'events';

  Future<List<EventModel>> readEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_eventsKey) ?? <String>[];
    return data
        .map((item) => EventModel.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeEvents(List<EventModel> events) async {
    final prefs = await SharedPreferences.getInstance();
    final payload =
        events.map((event) => jsonEncode(event.toJson())).toList(growable: false);
    await prefs.setStringList(_eventsKey, payload);
  }
}

