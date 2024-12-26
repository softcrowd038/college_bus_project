import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {
  final List<Map<String, String>> notifications = [
    {
      "heading": "New Message",
      "subheading": "You have received a new message."
    },
    {"heading": "System Update", "subheading": "Your system has been updated."},
    {
      "heading": "Event Reminder",
      "subheading": "Don't forget about the event tomorrow."
    },
    {
      "heading": "Server Maintenance",
      "subheading": "Scheduled server maintenance is upcoming."
    },
    {
      "heading": "New Feature",
      "subheading": "A new feature has been added to your app."
    },
    {
      "heading": "Account Alert",
      "subheading": "There was a login attempt from a new device."
    },
    {
      "heading": "Security Update",
      "subheading": "Security patches are now available."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var notification = notifications[index];
            return Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.03,
                        backgroundColor: Colors.red,
                        child: Text(
                          notification['heading']!.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['heading']!,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              notification['subheading']!,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                color: const Color.fromARGB(255, 161, 161, 161),
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
}
