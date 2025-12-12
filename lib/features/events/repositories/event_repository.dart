import '../../../core/services/notification_service.dart';
import '../../../core/storage/event_storage.dart';
import '../models/event_model.dart';

class EventRepository {
  EventRepository({
    required EventStorage storage,
    required NotificationService notificationService,
  })  : _storage = storage,
        _notificationService = notificationService;

  final EventStorage _storage;
  final NotificationService _notificationService;

  Future<List<EventModel>> loadEvents() => _storage.readEvents();

  Future<void> saveEvents(List<EventModel> events) => _storage.writeEvents(events);

  Future<void> scheduleNotification(EventModel event) async {
    await _notificationService.scheduleEventNotification(
      id: event.id.hashCode,
      title: event.title,
      body: '${event.location} • ${event.notes}',
      dateTime: event.dateTime,
    );
  }

  Future<void> cancelNotification(EventModel event) =>
      _notificationService.cancelNotification(event.id.hashCode);
}

