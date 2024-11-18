import 'package:flutter/material.dart';
import 'package:tt_9/main_view/main_fill_page.dart';
import 'package:tt_9/styles/app_theme.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;
  final GlobalKey _navBarKey = GlobalKey(); // Ключ для навигационной панели

  final List<Widget> _pages = [
    const MainFillPage(),
    const MainFillPage(),
    const MainFillPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: 50.0,
            left: 16.0,
            right: 100.0,
            child: Container(
              key: _navBarKey, // Установили ключ
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavBarItem(
                      icon: Icons.home_outlined,
                      isActive: _currentIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    _NavBarItem(
                      icon: Icons.file_copy_outlined,
                      isActive: _currentIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    _NavBarItem(
                      icon: Icons.settings_outlined,
                      isActive: _currentIndex == 2,
                      onTap: () => _onItemTapped(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 1,
            child: Container(
              height:
                  66, // Устанавливаем высоту в зависимости от навигационной панели
              width: 100,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 8, 36, 97),
                  shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;

  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              icon,
              color: isActive ? AppTheme.primary : Colors.grey,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
