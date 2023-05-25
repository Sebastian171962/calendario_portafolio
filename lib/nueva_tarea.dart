import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NuevaTarea extends StatefulWidget {
  final DateTime selectedDay;

  NuevaTarea({Key? key, required this.selectedDay, required events})
      : super(key: key);

  @override
  _NuevaTareaState createState() => _NuevaTareaState();
}

class _NuevaTareaState extends State<NuevaTarea> {
  final TextEditingController _tareaController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'Notification Body',
      platformChannelSpecifics,
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedStartTime != null) {
      setState(() {
        selectedStartTime = pickedStartTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedEndTime != null) {
      setState(() {
        selectedEndTime = pickedEndTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Add this line to set the background color
      appBar: AppBar(
        title: const Text('Nueva Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 70,
                  height: 70,
                  child: Image.asset('assets/profile_picture.png'),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 50),
                const Icon(
                  Icons.menu,
                  size: 32,
                  color: Color.fromRGBO(241, 216, 126, 1),
                ),
              ],
            ),
            const SizedBox(height: 20, width: 50),
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              calendarFormat: CalendarFormat.week,
              weekendDays: const [6, 7],
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Handle day selection
              },
              calendarStyle: const CalendarStyle(
                // Customize the text style for various calendar elements
                defaultTextStyle: TextStyle(
                    color: Colors.white), // Default day number text color
                weekendTextStyle: TextStyle(
                    color: Colors.white), // Weekend day number text color
                selectedTextStyle: TextStyle(
                    color: Colors.white), // Selected day number text color
                todayTextStyle: TextStyle(
                    color: Colors.white), // Today's day number text color
                outsideTextStyle: TextStyle(
                    color: Color.fromARGB(255, 228, 225,
                        225)), // Day number text color for days outside the current month
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tarea',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(241, 216, 126, 1),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: const Color.fromARGB(85, 224, 219, 236),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _tareaController,
                decoration: const InputDecoration(
                  hintText: 'Enter tarea',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nota',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(241, 216, 126, 1),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: const Color.fromARGB(85, 224, 219, 236),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _notaController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter nota',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              width: 500, // Ancho del Container
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Radio de los bordes
                color: const Color.fromARGB(85, 224, 219, 236),
              ),

              child: Stack(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 0),
                  child: const Text(
                    'Desde',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 216, 110),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextButton(
                    onPressed: () => _selectStartTime(context),
                    child: Text(
                      selectedStartTime != null
                          ? selectedStartTime!.format(context)
                          : 'Seleccione una hora',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 280),
                  child: const Text(
                    'Hasta',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 216, 110),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 50, left: 280),
                  child: TextButton(
                    onPressed: () => _selectEndTime(context),
                    child: Text(
                      selectedEndTime != null
                          ? selectedEndTime!.format(context)
                          : 'Seleccione una hora',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Perform cancel action
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 216, 110),
                    minimumSize: const Size(
                        165, 65), // Increase width and height as desired
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final tarea = _tareaController.text;
                    final nota = _notaController.text;

                    scheduleNotification(); // Schedule notification

                    Navigator.pop(
                      context,
                      {
                        'tarea': tarea,
                        'nota': nota,
                        'desde': selectedStartTime?.format(context),
                        'hasta': selectedEndTime?.format(context),
                      },
                    );
                  },
                  child: const Text(
                    'Guardar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 216, 110),
                    minimumSize: const Size(
                        165, 65), // Increase width and height as desired
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
