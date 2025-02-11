import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index); // 선택한 아이템의 인덱스를 설정
      },
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("홈"),
          selectedColor: Colors.blue,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.card_membership),
          title: const Text("티켓"),
          selectedColor: Colors.pink,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.fitness_center),
          title: const Text("트레이너"),
          selectedColor: Colors.orange,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.event_available),
          title: const Text("예약"),
          selectedColor: Colors.green,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.list),
          title: const Text("PT 리스트"),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.calendar_today),
          title: const Text("캘린더"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}
