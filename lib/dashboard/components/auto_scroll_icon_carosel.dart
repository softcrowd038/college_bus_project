import 'dart:async';
import 'package:college_bus_project/dashboard/components/container_reuse.dart';
import 'package:flutter/material.dart';

class AutoCarouselIcon extends StatefulWidget {
  const AutoCarouselIcon({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AutoCarouselIconState createState() => _AutoCarouselIconState();
}

class _AutoCarouselIconState extends State<AutoCarouselIcon> {
  late ScrollController _scrollController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < 3) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _scrollToIndex(_currentIndex);
    });
  }

  void _scrollToIndex(int index) {
    _scrollController.animateTo(
      index * MediaQuery.of(context).size.width,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).height * 0.010,
                top: MediaQuery.sizeOf(context).height * 0.015),
            child: ReuseContainer(
                color: Colors.white,
                speed: "Police",
                icon: Icons.local_police,
                height: MediaQuery.sizeOf(context).height * 0.150,
                width: MediaQuery.sizeOf(context).height * 0.150,
                size: 55,
                iconColor: Colors.blue),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).height * 0.010,
                top: MediaQuery.sizeOf(context).height * 0.015),
            child: ReuseContainer(
                color: Colors.white,
                speed: "Hospital",
                icon: Icons.local_hospital,
                height: MediaQuery.sizeOf(context).height * 0.150,
                width: MediaQuery.sizeOf(context).height * 0.150,
                size: 55,
                iconColor: Colors.red),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).height * 0.010,
                top: MediaQuery.sizeOf(context).height * 0.015),
            child: ReuseContainer(
                color: Colors.white,
                speed: "fire brigade",
                icon: Icons.fire_extinguisher,
                height: MediaQuery.sizeOf(context).height * 0.150,
                width: MediaQuery.sizeOf(context).height * 0.150,
                size: 55,
                iconColor: const Color.fromARGB(255, 255, 230, 1)),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).height * 0.010,
                  right: MediaQuery.sizeOf(context).height * 0.010,
                  top: MediaQuery.sizeOf(context).height * 0.015),
              child: ReuseContainer(
                color: Colors.white,
                speed: "Help Line",
                icon: Icons.help_center_rounded,
                height: MediaQuery.sizeOf(context).height * 0.150,
                width: MediaQuery.sizeOf(context).height * 0.150,
                size: 55,
                iconColor: Colors.orange,
              )),
        ],
      ),
    );
  }
}
