import 'package:audio_player/components/mini_player.dart';
import 'package:audio_player/providers/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
  }

  void goToSong(int index) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    Song tappedSong = musicProvider.songs[index];
    musicProvider.playSong(tappedSong.path, tappedSong.title, tappedSong.artist);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        return Scaffold(
          backgroundColor: theme.surface,
          appBar: AppBar(
            backgroundColor: theme.primary,
            title: Text(
              'F a v o r i t e s',
              style: TextStyle(color: theme.inversePrimary),
            ),
          ),
          body: Consumer<MusicProvider>(
            builder: (context, musicProvider, child) {
              final favoriteSongs = musicProvider.songs.where(
                    (song) => musicProvider.isFavorite(song.albumId),
              ).toList();

              return favoriteSongs.isEmpty
                  ? Center(
                child: Text(
                  'No Favorite songs yet!',
                  style: TextStyle(color: theme.secondary),
                ),
              )
                  : ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (context, index) {
                  Song song = favoriteSongs[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: song.albumId,
                      type: ArtworkType.AUDIO,
                      keepOldArtwork: true,
                      artworkBorder: BorderRadius.circular(8),
                      nullArtworkWidget:  Icon(
                        Icons.playlist_play,
                        size: 35,
                        color: theme.primary,
                      ),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.inversePrimary),
                    ),
                    subtitle: Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.primary),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        musicProvider.toggleFavorite(song.albumId);
                      },
                      icon: Icon(Icons.favorite, color: theme.inversePrimary),
                    ),
                    onTap: () => goToSong(index),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: musicProvider.audioPlayer.currentIndex == null
              ? null
              : const MiniPlayer(),
        );
      },
    );
  }
}
