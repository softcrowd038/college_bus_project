// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';

class PersonalInfoRow extends StatefulWidget {
  IconData icon;
  String title;
  String value;
  PersonalInfoRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  State<StatefulWidget> createState() => _PersonalInfoRow();
}

class _PersonalInfoRow extends State<PersonalInfoRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.018),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.025),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(1, 1),
                            color: Colors.black.withOpacity(0.2))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.008),
                    child: Icon(
                      widget.icon,
                      color: Colors.blue,
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.018,
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.height * 0.018),
              ),
            ],
          ),
          Text(widget.value)
        ],
      ),
    );
  }
}
