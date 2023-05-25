import 'package:flutter/material.dart';
import 'package:calendario/login_page.dart';
import 'package:calendario/main_view.dart' as MainView;
import 'package:calendario/nueva_tarea.dart';
import 'package:calendario/agenda_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => MainView.MainView(),
        '/nuevaTarea': (context) => NuevaTarea(
              selectedDay: DateTime.now(),
              events: null,
            ),
        '/agenda': (context) => AgendaView(
              selectedDay: DateTime.now(),
              tasks: const [],
              events: const {},
              onCreateEvent: (Event event) {
                // Handle event creation logic here
              },
            ),
      },
    );
  }
}
