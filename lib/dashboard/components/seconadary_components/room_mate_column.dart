import 'package:flutter/material.dart';

class RoomMateColumn extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String department;
  const RoomMateColumn(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.department});

  @override
  State<StatefulWidget> createState() => _RoomMateColumnState();
}

class _RoomMateColumnState extends State<RoomMateColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.110),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.110,
              width: MediaQuery.of(context).size.height * 0.110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.110)),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.0685,
            left: MediaQuery.of(context).size.height * 0.0360,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.0720),
              ),
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.008),
                child: Icon(
                  Icons.call,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.height * 0.0250,
                ),
              ),
            ),
          ),
        ]),
        Column(
          children: [
            Text(widget.name,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    fontWeight: FontWeight.w600)),
            Text(widget.department,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.010,
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ],
    );
  }
}
