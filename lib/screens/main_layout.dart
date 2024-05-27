import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/menu_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 300);
  bool isClosed = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: .85).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  toggleMenu() {
    setState(() {
      isClosed
          ? _animationController.forward()
          : _animationController.reverse();
      isClosed = !isClosed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MenuScreen(toggleMenu: toggleMenu),
        HomeScreen(
          scaleAnimation: _scaleAnimation,
          isClosed: isClosed,
          animationController: _animationController,
          duration: duration,
          toggleMenu: toggleMenu,
        ),
      ],
    );
  }
}
