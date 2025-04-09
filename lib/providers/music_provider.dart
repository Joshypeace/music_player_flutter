import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_player/models/album.dart';

enum PlaybackMode{ repeatAll, repeatOne, shuffle, }

enum SortOrder { defaultOrder, ascending, descending, dateModified }


class MusicProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<Song> songs = [];
  Set<int> favoriteSongs = {};
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int currentSongIndex = 0;
  bool _isLoading = true;
  PlaybackMode? playbackMode = PlaybackMode.repeatAll;
  List<int> shuffleOrder = [];
  bool isShuffled = false;
  Timer? _positionTimer;
  ValueNotifier<Duration> currentPosition  = ValueNotifier(Duration.zero);
  String searchQuery = '';
  SortOrder selectedSortOrder = SortOrder.defaultOrder;
  List<Album> _albums = [];
  
  

  MusicProvider() {
    _initAudioPlayer();
    _loadFavorites();
    requestPermission(); // Request permission on initialization
    _loadPlaybackMode();
    _listenForSongCompletion();
    _startPositionTracking();
    _loadSortingMethod();
  }

  void _initAudioPlayer() {
    audioPlayer.positionStream.listen((p) {
      position = p;
      notifyListeners();
    });
    audioPlayer.durationStream.listen((d) {
      duration = d ?? Duration.zero;
      notifyListeners();
    });
    audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  Future<void> requestPermission() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    if (Platform.isAndroid) {
      if (deviceInfo.version.sdkInt > 32) {
        if (await Permission.audio.isGranted) {
          await _loadSongs();
        } else {
          final status = await Permission.audio.request();
          if (status.isGranted) {
            await _loadSongs();
          }
        }
      } else {
        if (await Permission.storage.isGranted) {
          await _loadSongs();
        } else {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            await _loadSongs();
          }
        }
      }
    } else if (Platform.isIOS) {
      if (await Permission.mediaLibrary.isGranted) {
        await _loadSongs();
      } else {
        final status = await Permission.mediaLibrary.request();
        if (status.isGranted) {
          await _loadSongs();
        }
      }
    }
  }

  Future<void> _loadSongs() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<SongModel> fetchedSongs = await _audioQuery.querySongs();

      if (fetchedSongs.isNotEmpty) {
        songs = fetchedSongs
            .map((song) => Song(
          title: song.title,
          artist: song.artist ?? "Unknown Artist",
          path: song.data,
          albumId: song.id,
        )).toList();

      } else {
        //No songs Found
      }
    } catch (e) {
      //Error Loading songs
    }

    _isLoading = false;
    notifyListeners();
  }

  void playSong(String path, String title, String artist) async {
    final songIndex = songs.indexWhere((song) => song.path == path);
    if (songIndex == -1) return;

    currentSongIndex = songIndex;
    notifyListeners();

    try {
      await audioPlayer.setAudioSource(AudioSource.file(path));
      await audioPlayer.play();
    } catch (e) {
      //
    }
  }

  void _playSongAtIndex(int index) {
    if (index >= 0 && index < songs.length) {
      currentSongIndex = index;
      notifyListeners();

      playSong(songs[index].path,songs[index].title,songs[index].artist);
    }
  }

  void playNextSong() {
    if(playbackMode == PlaybackMode.repeatOne){
      _playSongAtIndex(currentSongIndex); // Repeat same song
      return;
    }
    
    if(isShuffled){
      int nextIndex = (shuffleOrder.indexOf(currentSongIndex) - 1 + shuffleOrder.length) %
          shuffleOrder.length;
      _playSongAtIndex(shuffleOrder[nextIndex]);
    }else{
      int nextIndex = (currentSongIndex + 1) % songs.length;
      _playSongAtIndex(nextIndex);
    }
  }

  void playPreviousSong() {
    final Duration currentPosition = audioPlayer.position;

    if (playbackMode == PlaybackMode.repeatOne) {
      _playSongAtIndex(currentSongIndex);
      return;
    }

    if (currentPosition.inSeconds > 0 && currentPosition.inSeconds < 15) {
      _playSongAtIndex(currentSongIndex);
      return;
    }

    int previousIndex;
    if (isShuffled) {
      previousIndex = (shuffleOrder.indexOf(currentSongIndex) - 1 + shuffleOrder.length) % shuffleOrder.length;
      _playSongAtIndex(shuffleOrder[previousIndex]);
    } else {
      previousIndex = (currentSongIndex - 1 + songs.length) % songs.length;
      _playSongAtIndex(previousIndex);
    }
  }


  void playPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    notifyListeners();
  }

  //Repeat and Shuffle
  void toggleRepeatMode() {
    if (playbackMode == null) {
      playbackMode = PlaybackMode.repeatAll;
    } else if (playbackMode == PlaybackMode.repeatAll) {
      playbackMode = PlaybackMode.repeatOne;
    } else {
      playbackMode = null;
    }
    _savePlaybackMode();
    notifyListeners();
  }

  void toggleShuffleMode(){
    isShuffled = !isShuffled;
    if(isShuffled){
      _generateShuffleOrder();
      currentSongIndex = shuffleOrder.indexOf(currentSongIndex);
    }
    _savePlaybackMode();
    notifyListeners();
  }

  void _generateShuffleOrder(){
     shuffleOrder = List.generate(songs.length, (index) => index)..shuffle();

  }


  void seek(Duration position) {
    audioPlayer.seek(position);
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  //Favorites
   Future<void> _loadFavorites() async {

     final prefs = await SharedPreferences.getInstance();
     final List<String>? storedFavorites = prefs.getStringList('favoriteSongs');

     if(storedFavorites != null){
       favoriteSongs = storedFavorites.map(int.parse).toSet();
       notifyListeners();
     }
   }

   Future<void> _saveFavorites() async{
     final prefs = await SharedPreferences.getInstance();
     await prefs.setStringList(
       'favoriteSongs',
       favoriteSongs.map((id) => id.toString()).toList()
     );
   }

   void toggleFavorite(int songId){
     if(favoriteSongs.contains(songId)){
       favoriteSongs.remove(songId);
     }else{
       favoriteSongs.add(songId);
     }
     _saveFavorites();
     notifyListeners();
   }

   bool isFavorite(int songId){
     return favoriteSongs.contains(songId);
   }


// Storing modes here


  Future<void> _loadPlaybackMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMode = prefs.getString('playback_mode');
    if(savedMode != null){
   playbackMode = PlaybackMode.values.firstWhere(
       (mode) => mode.toString() == savedMode,
     orElse:  () => PlaybackMode.repeatAll
   );
  }
    notifyListeners();
  }


  Future<void> _savePlaybackMode() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('playback_mode', playbackMode.toString());

  }


  void _listenForSongCompletion(){

     audioPlayer.processingStateStream.listen((state){
       if(state == ProcessingState.completed){
         playNextSong();
       }
     });

  }

  void _startPositionTracking(){
     _positionTimer = Timer.periodic(Duration(seconds: 1), (timer) async{
       currentPosition.value = audioPlayer.position;
     });
  }


  @override
  void dispose() {
     _positionTimer?.cancel();
     audioPlayer.dispose();
    super.dispose();
  }


  //ALBUMS
  List<Album> get albums => _albums;

   Future<void> fetchAlbums() async{
     bool hasPermission = await _audioQuery.permissionsRequest();
     if(!hasPermission){
       return;
     }

     List<AlbumModel> albumModels = await _audioQuery.queryAlbums();

     _albums = albumModels.map((albumModel){
       return Album(
           albumId: albumModel.id,
           albumName: albumModel.album,
           songs: getSongsForAlbum(albumModel.id),
       );

     }).toList();
     notifyListeners();
   }

  List<Song> getSongsForAlbum(int albumId) {
    return songs.where((song) => song.albumId == albumId).toList();
  }



//SEARCH ALGORITHM

  void updateSearchQuery(String query){
    searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<Song> get filteredSongs {
     return songs.where((song){
       return song.title.toLowerCase().contains(searchQuery) ||
              song.artist.toLowerCase().contains(searchQuery);
     }).toList();
  }


  //SORTING ALGORITHM

   Future<void> _loadSortingMethod() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? savedSort = prefs.getString('sort_order');

     if(savedSort != null){
       selectedSortOrder = SortOrder.values.firstWhere(
           (order) => order.toString() == savedSort,
         orElse:  () => SortOrder.defaultOrder,
       );
      _sortSongs();
     }
   }
   
   Future<void> _saveSortingMethod() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('sort_order', selectedSortOrder.toString());
   }

   
   void changeSortOrder(SortOrder newSortOrder){
     selectedSortOrder = newSortOrder;
     _saveSortingMethod();
     _sortSongs();
     notifyListeners();
   }
   
   void _sortSongs(){
     switch (selectedSortOrder) {
       case SortOrder.ascending:
         songs.sort((a,b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
         break;
       case SortOrder.descending:
         songs.sort((a,b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
         break;
       case SortOrder.dateModified:
         songs.sort((a, b) => (b.dateModified ?? DateTime(0)).compareTo(a.dateModified ?? DateTime(0)));
       default:
         songs.shuffle();
         break;
     }
     notifyListeners();
   }

}





