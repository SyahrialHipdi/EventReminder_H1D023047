import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/event_tile.dart';
import 'event_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<EventProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final events = provider.eventsForSelectedDay();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Reminder'),
      ),
      body: provider.initialized
          ? Column(
              children: [
                _CalendarSection(
                  focusedDay: provider.focusedDay,
                  selectedDay: provider.selectedDay,
                  events: provider.events,
                  onDaySelected: provider.onDaySelected,
                ),
                Expanded(
                  child: events.isEmpty
                      ? const Center(
                          child: Text('Belum ada event di tanggal ini'),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (_, index) {
                            final event = events[index];
                            return EventTile(
                              event: event,
                              onTap: () => _openForm(context, event),
                              onDelete: () => provider.delete(event),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemCount: events.length,
                        ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Event'),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, EventModel? event) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventFormPage(event: event),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<EventModel> events;
  final void Function(DateTime, DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final eventsByDay = <DateTime, List<EventModel>>{};
    for (final event in events) {
      final key = DateTime(event.dateTime.year, event.dateTime.month, event.dateTime.day);
      eventsByDay.putIfAbsent(key, () => []).add(event);
    }

    return SizedBox(
      height: 360,
      child: TableCalendar<EventModel>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDay,
        locale: 'id_ID',
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) =>
            day.year == selectedDay.year && day.month == selectedDay.month && day.day == selectedDay.day,
        onDaySelected: onDaySelected,
        eventLoader: (day) {
          final key = DateTime(day.year, day.month, day.day);
          return eventsByDay[key] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, dayEvents) {
            if (dayEvents.isEmpty) return null;
            return Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                spacing: 2,
                children: dayEvents
                    .take(3)
                    .map((e) => _ColorDot(color: e.color))
                    .toList(),
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextFormatter: (date, locale) => DateFormat('MMMM yyyy', locale).format(date),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

