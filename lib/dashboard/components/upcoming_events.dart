import 'package:college_bus_project/dashboard/components/seconadary_components/upcoming_events_container.dart';
import 'package:flutter/material.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<StatefulWidget> createState() => _UpcomingEvents();
}

class _UpcomingEvents extends State<UpcomingEvents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UpcomingEventsContainer(
            heading: 'Hostel Party',
            icon: Icons.celebration,
            subHeading: 'Join us for Fun Night'),
        UpcomingEventsContainer(
            heading: 'Maiintainance Notice',
            icon: Icons.sms_failed,
            subHeading: 'Water supply will be interrupt')
      ],
    );
  }
}
