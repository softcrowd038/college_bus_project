// ignore_for_file: deprecated_member_use

import 'package:college_bus_project/dashboard/components/seconadary_components/icon_widget.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/text_widget.dart';
import 'package:flutter/material.dart';

class ReuseContainer extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final String speed;
  final IconData icon;
  final double? height;
  final double? width;
  final double? size;

  const ReuseContainer(
      {super.key,
      required this.color,
      required this.speed,
      required this.icon,
      required this.height,
      required this.width,
      required this.size,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.020),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 1),
                spreadRadius: 2)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconWidget(
            icon: icon,
            size: size,
            color: iconColor,
          ),
          TextWidget(
            text1: speed,
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
