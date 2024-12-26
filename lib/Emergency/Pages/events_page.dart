import 'package:flutter/material.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  State<StatefulWidget> createState() => _UpcomingEventsPage();
}

class _UpcomingEventsPage extends State<UpcomingEventsPage> {
  final List<Map<String, String>> events = [
    {
      "event": "Tech Conference",
      "date": "2024-12-15",
      "icon": "event",
      "subheading": "Latest tech trends and innovations"
    },
    {
      "event": "Workshop on AI",
      "date": "2024-12-20",
      "icon": "engineering",
      "subheading": "Learn from AI experts"
    },
    {
      "event": "Product Launch",
      "date": "2024-12-25",
      "icon": "business",
      "subheading": "Get a sneak peek at our new product"
    },
    {
      "event": "Annual Meeting",
      "date": "2024-12-30",
      "icon": "people",
      "subheading": "Company-wide annual meet"
    },
    {
      "event": "Networking Session",
      "date": "2025-01-05",
      "icon": "connect_without_contact",
      "subheading": "Meet like-minded professionals"
    },
    {
      "event": "Hackathon",
      "date": "2025-01-10",
      "icon": "code",
      "subheading": "Coding competition with exciting prizes"
    },
    {
      "event": "Webinar on Flutter",
      "date": "2025-01-15",
      "icon": "web",
      "subheading": "Learn Flutter with experts"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            var event = events[index];
            return Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.012),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.008),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 38, 38),
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.05),
                        ),
                        child: Icon(
                          _getEventIcon(event['icon']!),
                          size: MediaQuery.of(context).size.height * 0.038,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['event']!,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.008),
                            Text(
                              "Date: ${event['date']}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.018,
                                color: const Color.fromARGB(255, 161, 161, 161),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.008),
                            Text(
                              event['subheading'] ?? '',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.016,
                                color: const Color.fromARGB(255, 130, 130, 130),
                              ),
                            ),
                          ],
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
    );
  }

  IconData _getEventIcon(String iconName) {
    switch (iconName) {
      case 'event':
        return Icons.event;
      case 'engineering':
        return Icons.engineering;
      case 'business':
        return Icons.business;
      case 'people':
        return Icons.people;
      case 'connect_without_contact':
        return Icons.connect_without_contact;
      case 'code':
        return Icons.code;
      case 'web':
        return Icons.web;
      default:
        return Icons.event;
    }
  }
}
