import 'package:flutter/material.dart';
import 'package:touristop/screens/main/map/map_screen.dart';
import 'package:touristop/screens/main/schedule/schedule_screen.dart';
import 'package:touristop/theme/app_colors.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BAB(
        pageController: _pageController,
        currentPage: _currentPage,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: const [
          MapScreen(),
          ScheduleScreen(),
        ],
      ),
    );
  }
}

class BAB extends StatelessWidget {
  const BAB({
    Key? key,
    required PageController pageController,
    required int currentPage,
  })  : _pageController = pageController,
        _currentPage = currentPage,
        super(key: key);

  final PageController _pageController;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavItem(
            icon: Icons.map,
            pageController: _pageController,
            page: 0,
            currentPage: _currentPage,
          ),
          BottomNavItem(
            icon: Icons.schedule,
            pageController: _pageController,
            page: 1,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    Key? key,
    required this.icon,
    required this.pageController,
    required this.page,
    required this.currentPage,
  }) : super(key: key);

  final IconData icon;
  final PageController pageController;
  final int page;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              pageController.jumpToPage(page);
            },
            child: Icon(
              icon,
              color: currentPage == page ? AppColors.coldBlue : Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
