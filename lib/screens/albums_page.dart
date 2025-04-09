import 'package:audio_player/providers/music_provider.dart';
import 'package:audio_player/screens/inside_album.dart';
import 'package:audio_player/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch albums when the page is initialized
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    musicProvider.fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final musicProvider = Provider.of<MusicProvider>(context);
    final albums = musicProvider.albums;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text(
          'A l b u m s',
          style: TextStyle(color: theme.inversePrimary),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.settings,
                color: theme.inversePrimary,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: albums.isEmpty
            ? Center(
          child: Text(
            'No albums found',
            style: TextStyle(color: theme.inversePrimary),
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsideAlbum(album: album),
                  ),
                );
              },
              child: Card(
                color: theme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QueryArtworkWidget(
                      id: album.albumId, // Use album.id instead of album.albumId
                      type: ArtworkType.ALBUM,
                      artworkBorder: BorderRadius.circular(10),
                      keepOldArtwork: true,
                      nullArtworkWidget: Icon(
                        Icons.album,
                        size: 50,
                        color: theme.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      album.albumName, // Use album.album instead of album.albumName
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.inversePrimary, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${musicProvider.getSongsForAlbum(album.albumId).length}  Songs",
                      style: TextStyle(
                          color: theme.inversePrimary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}