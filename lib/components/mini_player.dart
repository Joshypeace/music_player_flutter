import 'package:audio_player/providers/music_provider.dart';
import 'package:audio_player/screens/now_playing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:marquee/marquee.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // Fetch theme colors

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NowPlaying()),
        );
      },
      child: BottomAppBar(
        color: theme.primary.withAlpha(50), // Background with transparency
        height: 65,
        child: Consumer<MusicProvider>(
          builder: (context, musicProvider, child) {
            if (musicProvider.audioPlayer.currentIndex == null ||
                musicProvider.currentSongIndex < 0 ||
                musicProvider.currentSongIndex >= musicProvider.songs.length) {
              return const SizedBox(); // Prevents crashes if no song is playing
            }

            final song = musicProvider.songs[musicProvider.currentSongIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Album Artwork or Placeholder
                  QueryArtworkWidget(
                    id: song.albumId,
                    type: ArtworkType.AUDIO,
                    keepOldArtwork: true,
                    artworkBorder: BorderRadius.circular(10),
                    nullArtworkWidget: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: theme.primary, // Adjusted opacity
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.music_note,
                        size: 24,
                        color: theme.tertiary.withAlpha(200), // Adjusted color
                      ),
                    ),
                    artworkFit: BoxFit.cover,
                  ),

                  const SizedBox(width: 14), // Space between artwork and text

                  // Scrolling Song Title & Artist
                  Expanded(
                    child: Marquee(
                      text: "${song.title} || ${song.artist}",
                      style: TextStyle(color: theme.inversePrimary, fontSize: 16), // Themed text color
                      scrollAxis: Axis.horizontal,
                      blankSpace: 40.0,
                      velocity: 25.0,
                      pauseAfterRound: const Duration(seconds: 2),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.easeIn,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),

                  const SizedBox(width: 14), // Space between text and button

                  // Play/Pause Button
                  GestureDetector(
                    onTap: () => musicProvider.playPause(),
                    child: Icon(
                      musicProvider.audioPlayer.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 36,
                      color: theme.inversePrimary.withAlpha(200), // Adjusted opacity
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
