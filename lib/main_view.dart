import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import 'nueva_tarea.dart';

class Event {
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;

  Event(this.title, this.description, this.startTime, this.endTime);
}

class MainView extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _addOrEditEvent(BuildContext context, DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 245, 216, 110),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/nuevaTarea',
                      arguments: {'selectedDay': selectedDay}).then((result) {
                    if (result != null && result is Map<String, dynamic>) {
                      final String? tarea = result['tarea'] as String?;
                      final String? nota = result['nota'] as String?;

                      if (tarea != null && tarea.isNotEmpty) {
                        final newEvent = Event(
                            tarea,
                            nota ?? '',
                            DateTime.now(),
                            DateTime.now().add(const Duration(hours: 1)));
                        if (events.containsKey(selectedDay)) {
                          events[selectedDay]!.add(newEvent);
                        } else {
                          events[selectedDay] = [newEvent];
                        }
                        setState(() {});

                        showConfirmationNotification(selectedDay, newEvent);
                      }
                    }
                  });
                },
                child: const Text('Nueva tarea'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/agenda', arguments: {
                    'selectedDay': selectedDay,
                    'events': events
                  });
                },
                child: const Text('Ir a agenda'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveEvent(
    DateTime selectedDay,
    String eventTitle,
    String eventDescription,
    DateTime startTime,
    DateTime endTime,
  ) {
    if (eventTitle.isNotEmpty) {
      final newEvent = Event(eventTitle, eventDescription, startTime, endTime);
      if (events.containsKey(selectedDay)) {
        events[selectedDay]!.add(newEvent);
      } else {
        events[selectedDay] = [newEvent];
      }
      setState(() {});

      showConfirmationNotification(selectedDay, newEvent);
    }
  }

  void showConfirmationNotification(DateTime selectedDay, Event event) async {
    // Display a pop-up notification with options
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('¿Ya terminaste tu trabajo?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('yes');
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('no');
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ).then((response) {
      if (response == 'yes') {
        // User selected 'Yes', perform the desired action
        // Navigate to 'nueva_tarea.dart'
        Navigator.pushNamed(context, '/nueva_tarea',
            arguments: {'selectedDay': selectedDay});
      } else if (response == 'no') {
        // User selected 'No', show another notification
        showSecondNotification(selectedDay, event);
      }
    });
  }

  void showSecondNotification(DateTime selectedDay, Event event) async {
    // Display a pop-up notification with options
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              '¿Por qué no has acabado tu tarea, pedazo de !@#? ¿Deseas reprogramar?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('reprogram');
              },
              child: const Text('Sí'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('no');
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    ).then((response) {
      if (response == 'reprogram') {
        // User selected 'Sí', perform the desired action
        // Navigate to 'nueva_tarea.dart'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NuevaTarea(
              selectedDay: selectedDay,
              events: null,
            ),
          ),
        );
      } else if (response == 'no') {
        // User selected 'No', perform the desired action
        // Delete the event
        events[selectedDay]!.remove(event);
        if (events[selectedDay]!.isEmpty) {
          events.remove(selectedDay);
        }
        setState(() {});
      }
    });
  }

  void _editEventTitle(
      BuildContext context, DateTime selectedDay, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedTitle = event.title;

        return AlertDialog(
          title: const Text('Edit Event Title'),
          content: TextField(
            onChanged: (value) {
              updatedTitle = value;
            },
            controller: TextEditingController(text: event.title),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateEventTitle(selectedDay, event, updatedTitle);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateEventTitle(
      DateTime selectedDay, Event event, String updatedTitle) {
    event.title = updatedTitle;
    setState(() {});
  }

  Widget _buildEventMarker(int eventCount) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          eventCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 6,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Did you finish your task?',
      '',
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
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
            const SizedBox(height: 20),
            TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _addOrEditEvent(context, selectedDay);
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final eventCount = events.length;
                  if (eventCount > 0) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventMarker(eventCount),
                    );
                  }
                },
              ),
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
                    color: Colors
                        .grey), // Day number text color for days outside the current month
              ),
            ),
            const SizedBox(height: 20),
            _selectedDay != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final days = events.keys.toList()..sort();
                        final day = days[index];
                        final dayEvents = events[day] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    DateFormat('d MMM').format(day),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: dayEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = dayEvents[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetailsView(
                                                      event: event),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event.title,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  event.description,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'From ${DateFormat('h:mm a').format(event.startTime)} to ${DateFormat('h:mm a').format(event.endTime)}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class EventDetailsView extends StatefulWidget {
  final Event event;

  const EventDetailsView({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsViewState createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  String response = '';

  Future<void> generateResponseFromDescription(String description) async {
    try {
      final openai = OpenAIGpt3Api('YOUR_API_KEY');
      final generateResponse = await openai.generateResponse(
        description,
        temperature: 0.7,
        maxTokens: 50,
      );

      setState(() {
        response = generateResponse.choices.first.text;
      });
    } catch (e) {
      print('Error generating response: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    generateResponseFromDescription(widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.event.description),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'From ${DateFormat('h:mm a').format(widget.event.startTime)} to ${DateFormat('h:mm a').format(widget.event.endTime)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Response:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(response),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OpenAIGpt3Api(String s) {}
}
