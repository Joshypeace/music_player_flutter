import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../models/album.dart';
import '../providers/music_provider.dart';

class InsideAlbum extends StatelessWidget {
  final Album album;
  const InsideAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final musicProvider = Provider.of<MusicProvider>(context);
    final songs = musicProvider.getSongsForAlbum(album.albumId);


    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        title: Text(
          album.albumName,
          style: TextStyle(color: theme.inversePrimary),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.inversePrimary),
      ),
      body: songs.isEmpty
          ? Center(
        child: Text(
          "No songs found in this album",
          style: TextStyle(color: theme.inversePrimary),
        ),
      )
          : ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
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
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.music_note,
                  size: 35,
                  color: theme.primary,
                ),
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
              style: TextStyle(color: theme.primary),
            ),
            onTap: () {
              Provider.of<MusicProvider>(context, listen: false)
                  .playSong(song.path, song.artist, song.title);
            },
          );
        },
      ),
    );
  }
}
