import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/music_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final musicProvider = Provider.of<MusicProvider>(context);
    final filteredSongs = musicProvider.filteredSongs;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: theme.onSurface),
          decoration: InputDecoration(
            hintText: "Search songs...",
            hintStyle: TextStyle(color: theme.inversePrimary),
          ),
          onChanged: (query) {
            musicProvider.updateSearchQuery(query);
          },
        ),
        iconTheme: IconThemeData(color: theme.onSurfaceVariant),
      ),
      body: _searchController.text.isEmpty
          ? _buildSuggestions(context, musicProvider)
          : _buildSearchResults(context, filteredSongs),
    );
  }
}

Widget _buildSuggestions(BuildContext context, MusicProvider musicProvider) {
  final theme = Theme.of(context).colorScheme;
  final List<Song> topSongs = musicProvider.songs.take(5).toList();

  return ListView.builder(
    itemCount: topSongs.length,
    itemBuilder: (context, index) {
      final song = topSongs[index];
      return ListTile(
        leading: Icon(Icons.music_note, color: theme.primary),
        title: Text(song.title, style: TextStyle(color: theme.inversePrimary)),
        subtitle: Text(song.artist, style: TextStyle(color: theme.primary)),
        onTap: () {
          musicProvider.playSong(song.path, song.title, song.artist);
          Navigator.pop(context);
        },
      );
    },
  );
}

Widget _buildSearchResults(BuildContext context, List<Song> filteredSongs) {
  final theme = Theme.of(context).colorScheme;

  return filteredSongs.isEmpty
      ? Center(
    child: Text(
      'Match not found',
      style: TextStyle(color: theme.inversePrimary),
    ),
  )
      : ListView.builder(
    itemCount: filteredSongs.length,
    itemBuilder: (context, index) {
      final song = filteredSongs[index];
      return ListTile(
        leading: Icon(Icons.music_note, color: theme.primary),
        title: Text(song.title, style: TextStyle(color: theme.inversePrimary)),
        subtitle: Text(song.artist, style: TextStyle(color: theme.primary)),
        onTap: () {
          Provider.of<MusicProvider>(context, listen: false).playSong(song.path, song.title, song.artist);
          Navigator.pop(context);
        },
      );
    },
  );
}
