import 'package:audio_player/screens/albums_page.dart';
import 'package:audio_player/screens/favorites_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  List<Widget> pages = [
    HomePage(),
    AlbumsPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.primary.withAlpha(220), // Darker background
        selectedItemColor: theme.secondary, // Selected item color
        unselectedItemColor: theme.inversePrimary.withAlpha(200), // Unselected item color
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.music_note, size: 34),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.adjust, size: 34),
            label: 'Albums',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_circle, size: 34),
            label: 'Favorites',
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
