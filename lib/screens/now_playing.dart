import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import 'package:audio_player/components/neu_box.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key, this.song});

  final Song? song;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // Fetch color scheme

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text(
          'N o w  P l a y i n g',
          style: TextStyle(color: theme.inversePrimary),
        ),
        iconTheme: IconThemeData(color: theme.inversePrimary),
      ),
      backgroundColor: theme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Consumer<MusicProvider>(
                      builder: (context, musicProvider, child) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.primary
                            ),
                            child: QueryArtworkWidget(
                              id: musicProvider.songs[musicProvider.currentSongIndex].albumId,
                              type: ArtworkType.AUDIO,
                              artworkHeight: 265,
                              artworkWidth: 400,
                              artworkBorder: BorderRadius.circular(10),
                              artworkQuality: FilterQuality.high,
                              keepOldArtwork: true,
                              nullArtworkWidget: Center(
                                child:  Icon(
                                  Icons.music_note,
                                  size: 265,
                                  color: theme.surface,

                                ),
                              ),
                              artworkFit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Song Title and Favorite Icon
                  Consumer<MusicProvider>(
                    builder: (context, musicProvider, child) {
                      Song currentSong = musicProvider.songs[musicProvider.currentSongIndex];
                      final isFavorite = musicProvider.isFavorite(currentSong.albumId);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.inversePrimary,
                              ),
                            ),
                          ),
                           SizedBox(width: 60,),
                           GestureDetector(
                             onTap:(){
                               musicProvider.toggleFavorite(currentSong.albumId);
                             },
                             child: Padding(
                               padding: const EdgeInsets.only(right: 5),
                               child: Icon(
                                   isFavorite ? Icons.favorite : Icons.favorite_border,
                                   color: isFavorite ? Colors.red : Colors.grey.shade700,
                                   size: 30,
                               ),
                             ),
                           )
                        ],
                      );
                    },
                  ),
                  // Artist Name
                  Consumer<MusicProvider>(
                    builder: (context, musicProvider, child) {
                      Song currentSong = musicProvider.songs[musicProvider.currentSongIndex];
                      return Text(
                        currentSong.artist,
                        style:  TextStyle(fontSize: 16, color: Colors.grey),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Time Labels & Shuffle / Repeat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<MusicProvider>(
                    builder: (context, musicProvider, child) {
                      return Text(
                        _formatDuration(musicProvider.position),
                        style: TextStyle(color: theme.inversePrimary, fontSize: 16),
                      );
                    },
                  ),
                   Consumer<MusicProvider>(builder: (context, musicProvider,child){
                       return GestureDetector(
                         onTap: () => musicProvider.toggleShuffleMode(),
                         child: Icon(
                           CupertinoIcons.shuffle,
                           color: musicProvider.isShuffled ? Colors.blue : Colors.grey
                         )
                       );
                   }
                   ),
                  Consumer<MusicProvider>(builder: (context, musicProvider,child){
                       return GestureDetector(
                         onTap: () => musicProvider.toggleRepeatMode(),
                         child: Icon(
                           musicProvider.playbackMode == PlaybackMode.repeatOne ?
                           CupertinoIcons.repeat_1 :
                           musicProvider.playbackMode == PlaybackMode.repeatAll ?
                           CupertinoIcons.repeat : CupertinoIcons.repeat,
                             color: musicProvider.playbackMode == PlaybackMode.repeatOne ?
                             Colors.blue: musicProvider.playbackMode == PlaybackMode.repeatAll ?
                           Colors.blue : Colors.grey
                         ),
                       );
                   }
                   ),

                  Consumer<MusicProvider>(
                    builder: (context, musicProvider, child) {
                      return Text(
                        _formatDuration(musicProvider.duration),
                        style: TextStyle(color: theme.inversePrimary, fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Seek Bar
            Consumer<MusicProvider>(
              builder: (context, musicProvider, child) {
                return SliderTheme(
                  data: const SliderThemeData(thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)),
                  child: Slider(
                    min: 0,
                    max: musicProvider.duration.inSeconds.toDouble(),
                    value: musicProvider.position.inSeconds.toDouble(),
                    onChanged: (double double) {
                      musicProvider.seek(Duration(seconds: double.toInt()));
                    },
                    activeColor: Colors.blue,
                    inactiveColor: theme.primary,
                  ),
                );
              },
            ),
            SizedBox(height: 30,),
            // Playback Controls (Previous, Play/Pause, Next)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Provider.of<MusicProvider>(context, listen: false).playPreviousSong(),
                      child: NeuBox(
                          child: Icon(Icons.skip_previous, size: 30, color: theme.inversePrimary)),
                    ),
                  ),
                   SizedBox(width: 20,),
                   Consumer<MusicProvider>(
                    builder: (context, musicProvider, child) {
                      return Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => musicProvider.playPause(),
                          child: NeuBox(
                            child: Icon(
                              musicProvider.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                              size: 35,
                              color: theme.inversePrimary,
                            ),
                          ),
                        ),
                       );
                    },
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Provider.of<MusicProvider>(context, listen: false).playNextSong(),
                      child: NeuBox(
                          child: Icon(
                              Icons.skip_next, size: 30, color: theme.inversePrimary)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to format duration in MM:SS
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}
