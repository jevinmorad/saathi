import 'package:flutter/material.dart';
import 'package:saathi/screens/UserSwipeScreen.dart';
import 'package:saathi/screens/drawer.dart';
import 'package:saathi/screens/favourite_screen.dart';
import 'package:saathi/screens/search_screen.dart';
import 'add_user_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  final List<GlobalKey> _screenKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final List<Widget> _screens = [
    AddUserScreen(),
    UserSwipeScreen(),
    SearchScreen(),
    FavouriteScreen(),
  ];

  final List<String> _screensTitle = [
    'Add User',
    'Saathi',
    'About Us',
    'Favourites',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _screenKeys[index] = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 2 ? AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF2C3E50),
        title: Text(
          _screensTitle[_selectedIndex],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.message_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ) : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          KeyedSubtree(
            key: _screenKeys[0],
            child: _screens[0],
          ),
          KeyedSubtree(
            key: _screenKeys[1],
            child: _screens[1],
          ),
          KeyedSubtree(
            key: _screenKeys[2],
            child: _screens[2],
          ),
          KeyedSubtree(
            key: _screenKeys[3],
            child: _screens[3],
          ),
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedItemColor: Color(0xFFE83E8C),
          unselectedItemColor: Color(0xFF6c757d),
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_outlined),
              activeIcon: Icon(Icons.app_registration_rounded, color: Color(0xFFE83E8C)),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt, color: Color(0xFFE83E8C)),
              label: 'Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search_rounded, color: Color(0xFFE83E8C)),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded),
              activeIcon: Icon(Icons.favorite_outlined, color: Color(0xFFE83E8C)),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}