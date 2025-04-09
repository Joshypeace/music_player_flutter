import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Listen to changes

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Light/Dark surface
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // Main color
        title: Text(
          'L i g h t / D a r k',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary, // High contrast text
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary, // Ensure visibility
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, // Secondary for contrast
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary, // Text contrast
              ),
            ),
            CupertinoSwitch(
              value: themeProvider.isDarkMode,
              activeTrackColor: Theme.of(context).colorScheme.primary, // Matches theme
              onChanged: (value) => themeProvider.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
