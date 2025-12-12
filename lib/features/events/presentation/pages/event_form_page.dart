import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/color_selector.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, this.event});

  final EventModel? event;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _dateTime;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _titleController = TextEditingController(text: event?.title ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _notesController = TextEditingController(text: event?.notes ?? '');
    _dateTime = event?.dateTime ?? DateTime.now();
    _colorValue = event?.colorValue ?? Colors.teal.value;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Ubah Event' : 'Tambah Event'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<EventProvider>().delete(widget.event!);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Event',
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama event wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Tempat',
                  prefixIcon: Icon(Icons.place),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _DateTimePicker(
                value: _dateTime,
                onChanged: (value) => setState(() => _dateTime = value),
              ),
              const SizedBox(height: 12),
              ColorSelector(
                selectedColor: Color(_colorValue),
                onColorSelected: (color) => setState(() => _colorValue = color.value),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<EventProvider>();
    final event = (widget.event ??
            EventModel(
              title: _titleController.text,
              location: _locationController.text,
              notes: _notesController.text,
              dateTime: _dateTime,
              colorValue: _colorValue,
            ))
        .copyWith(
      title: _titleController.text,
      location: _locationController.text,
      notes: _notesController.text,
      dateTime: _dateTime,
      colorValue: _colorValue,
    );

    await provider.addOrUpdate(event);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    required this.value,
    required this.onChanged,
  });

  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(value);
    final timeText = DateFormat('HH:mm').format(value);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(dateText),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                locale: const Locale('id', 'ID'),
              );
              if (picked != null) {
                onChanged(DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  value.hour,
                  value.minute,
                ));
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.access_time),
            label: Text(timeText),
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value),
              );
              if (picked != null) {
                onChanged(DateTime(
                  value.year,
                  value.month,
                  value.day,
                  picked.hour,
                  picked.minute,
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}

