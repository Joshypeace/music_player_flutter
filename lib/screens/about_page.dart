import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text('About the Developer', style: TextStyle(color: theme.inversePrimary)),
        iconTheme: IconThemeData(color: theme.inversePrimary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/josh.jpeg'),
              ),
              SizedBox(height: 15),
              Text(
                "Joshua Chilapondwa",
                style: TextStyle(color: theme.inversePrimary, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Lead Developer & Designer",
                style: TextStyle(color: theme.inversePrimary, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "This app was designed and developed with passion to deliver the best music experience.",
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.inversePrimary, fontSize: 16),
              ),
              SizedBox(height: 25),
              _buildRoleCard("🎨 UI/UX Design", "Crafted a modern, user-friendly interface for seamless navigation.", theme),
              _buildRoleCard("💻 App Development", "Built the app using Flutter & Dart, ensuring smooth performance.", theme),
              _buildRoleCard("🎵 Music Integration", "Implemented local music playback with album & song management.", theme),
              _buildRoleCard("📡 Data Persistence", "Used SharedPreferences to remember user settings & preferences.", theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String title, String description, ColorScheme theme) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, style: TextStyle(color: theme.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.white70, fontSize: 14)),
      ),
    );
  }
}
