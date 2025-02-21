// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';

class UpcomingEventsContainer extends StatefulWidget {
  IconData? icon;
  String heading;
  String subHeading;
  UpcomingEventsContainer(
      {super.key,
      required this.heading,
      required this.icon,
      required this.subHeading});

  @override
  State<StatefulWidget> createState() => _UpcomingEventsContainer();
}

class _UpcomingEventsContainer extends State<UpcomingEventsContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.0180),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.0720),
            ),
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.0300,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.018,
          ),
          Column(
            children: [
              Text(widget.heading,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.018,
                      fontWeight: FontWeight.w600)),
              Text(widget.subHeading,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: MediaQuery.of(context).size.height * 0.012,
                      fontWeight: FontWeight.w300)),
            ],
          ),
        ],
      ),
    );
  }
}
