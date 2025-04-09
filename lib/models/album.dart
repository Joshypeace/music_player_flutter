import 'package:audio_player/models/song.dart';

class Album{
  final int albumId;
  final String albumName;
  final List<Song> songs;

  Album({
   required this.albumId,
   required this.albumName,
   required this.songs,
});

}