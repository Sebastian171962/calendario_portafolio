import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;

  Event(this.title, this.description, this.startTime, this.endTime);
}

class AgendaView extends StatelessWidget {
  final DateTime selectedDay;
  final Map events;
  final List tasks;

  const AgendaView({
    required this.selectedDay,
    required this.events,
    required this.tasks,
    required Null Function(Event event) onCreateEvent,
  });

  List<Event> getEventsForSelectedDay() {
    return [
      Event(
        'Event 1',
        'Description of Event 1',
        DateTime.now(),
        DateTime.now().add(Duration(hours: 1)),
      ),
      Event(
        'Event 2',
        'Description of Event 2',
        DateTime.now().add(Duration(hours: 1)),
        DateTime.now().add(Duration(hours: 2)),
      ),
      Event(
        'Event 3',
        'Description of Event 3',
        DateTime.now().add(Duration(hours: 2)),
        DateTime.now().add(Duration(hours: 3)),
      ),
      // Add the remaining 7 events here
      // ...
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Event> eventsForSelectedDay = getEventsForSelectedDay();

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      backgroundColor: Colors.black, // Add this line
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 60,
                  height: 60,
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
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              calendarFormat: CalendarFormat.week,
              weekendDays: [6, 7],
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Handle day selection
              },
              calendarStyle: CalendarStyle(
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
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: eventsForSelectedDay.length,
              itemBuilder: (context, index) {
                Event event = eventsForSelectedDay[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsView(event: event),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 115, 90, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            event.description,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'From ${DateFormat('h:mm a').format(event.startTime)} to ${DateFormat('h:mm a').format(event.endTime)}',
                            style: TextStyle(
                              color: Colors.white,
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
    );
  }
}

class EventDetailsView extends StatelessWidget {
  final Event event;

  const EventDetailsView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(event.description),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Add this line
                crossAxisAlignment: CrossAxisAlignment.center, // Add this line
                children: [
                  Text(
                    'Time:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'From ${DateFormat('h:mm a').format(event.startTime)} to ${DateFormat('h:mm a').format(event.endTime)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
