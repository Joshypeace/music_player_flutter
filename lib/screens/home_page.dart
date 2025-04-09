import 'package:audio_player/components/mini_player.dart';
import 'package:audio_player/components/popup_menu.dart';
import 'package:audio_player/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    musicProvider.requestPermission();
  }

  void goToSong(int index) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    Song tappedSong = musicProvider.songs[index];
    musicProvider.playSong(tappedSong.path, tappedSong.title, tappedSong.artist);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // Fetch color scheme

    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        return Scaffold(
          backgroundColor: theme.surface, // Background color
          appBar: AppBar(
            backgroundColor: theme.primary, // AppBar color
            title: Text(
              'S o n g s',
              style: TextStyle(color: theme.inversePrimary), // Title text color
            ),
            actions: const [
              PopMenu()
            ],
          ),
          body: musicProvider.isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: theme.secondary, // Loader color
            ),
          )
              : musicProvider.songs.isEmpty
              ? Center(
            child: Text(
              'No songs found',
              style: TextStyle(color: theme.inversePrimary, fontSize: 14),
            ),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
            child: ListView.builder(
              itemCount: musicProvider.songs.length,
              itemBuilder: (context, index) {
                Song song = musicProvider.songs[index];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.albumId,
                    type: ArtworkType.AUDIO,
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(8),
                    nullArtworkWidget: Container(
                      width: 55,
                      height: 70,
                      decoration: BoxDecoration(
                        color: theme.primary.withAlpha(130), // Adjusted using withAlpha
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.music_note,
                        size: 35,
                        color: theme.secondary, // Icon color
                      ),
                    ),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.inversePrimary), // Title color
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey), // Subtitle color
                  ),
                  onTap: () => goToSong(index),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                ),
              );
            },
            backgroundColor: theme.primary, // Button background
            child: Icon(
              Icons.search,
              color: theme.secondary, // Search icon color
              size: 28,
            ),
          ),
          bottomNavigationBar: musicProvider.audioPlayer.currentIndex == null ? null : const MiniPlayer(),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
