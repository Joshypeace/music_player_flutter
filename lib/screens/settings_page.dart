import 'package:audio_player/screens/about_page.dart';
import 'package:audio_player/screens/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player/theme/theme_provider.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('S e t t i n g s',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary, // High contrast text
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.inversePrimary, // Ensure visibility
          ),
        ),
      body: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>ThemeSwitch()));
            },
            leading: Icon(
              Icons.lightbulb_outlined,
              size: 32,color: Colors.yellow.shade900,),
            title: Text(
                'App Theme',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
                'clear here to switch you app theme',
                 style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(Icons.arrow_right,color: Colors.grey,),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>AboutPage()));
            },
            leading: Icon(Icons.info_outline,size: 32,color: Colors.green,),
            title: Text(
                'About',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,fontWeight: FontWeight.bold

              ),
            ),
            subtitle: Text(
                'clear here to know more about the app',
              style: TextStyle(color: Colors.grey),

            ),
            trailing: Icon(Icons.arrow_right,color: Colors.grey,),
          ),

        ],
      ),
    );
  }
}
