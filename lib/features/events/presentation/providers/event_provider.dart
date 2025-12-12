import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/event_storage.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';

class EventProvider extends ChangeNotifier {
  EventProvider({required NotificationService notificationService})
      : repository = EventRepository(
          storage: EventStorage(),
          notificationService: notificationService,
        ),
        notificationChannel = notificationService.defaultChannel;

  final EventRepository repository;
  final AndroidNotificationChannel notificationChannel;
  final navigatorKey = GlobalKey<NavigatorState>();

  List<EventModel> _events = [];
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _initialized = false;

  List<EventModel> get events => _events;
  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  bool get initialized => _initialized;

  List<EventModel> eventsForSelectedDay() {
    return _events
        .where((event) =>
            event.dateTime.year == _selectedDay.year &&
            event.dateTime.month == _selectedDay.month &&
            event.dateTime.day == _selectedDay.day)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  Future<void> load() async {
    _events = await repository.loadEvents();
    _initialized = true;
    notifyListeners();
  }

  Future<void> addOrUpdate(EventModel event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      _events[index] = event;
      await repository.cancelNotification(event);
    } else {
      _events.add(event);
    }
    await repository.saveEvents(_events);
    await repository.scheduleNotification(event);
    notifyListeners();
  }

  Future<void> delete(EventModel event) async {
    _events.removeWhere((e) => e.id == event.id);
    await repository.saveEvents(_events);
    await repository.cancelNotification(event);
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    _focusedDay = focusedDay;
    notifyListeners();
  }
}

