import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/events/presentation/pages/home_page.dart';
import 'features/events/presentation/providers/event_provider.dart';

class EventReminderApp extends StatelessWidget {
  const EventReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventProvider>();
    return MaterialApp(
      title: 'Event Reminder',
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      navigatorKey: eventProvider.navigatorKey,
      home: const HomePage(),
    );
  }
}

