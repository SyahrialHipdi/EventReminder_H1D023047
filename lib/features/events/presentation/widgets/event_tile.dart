import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
    required this.onDelete,
  });

  final EventModel event;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(event.dateTime);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: event.color.withOpacity(0.15),
          child: Icon(Icons.event, color: event.color),
        ),
        title: Text(event.title),
        subtitle: Text('$time • ${event.location.isEmpty ? 'Tanpa lokasi' : event.location}\n${event.notes}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

