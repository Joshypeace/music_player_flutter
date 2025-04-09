class Song {
  final String title;
  final String artist;
  final String path;
  final int albumId;
  final String? albumName;
  final DateTime? dateModified;

  Song({
    required this.title,
    required this.artist,
    required this.path,
    required this.albumId,
    this.albumName,
    this.dateModified
});

  factory Song.empty(){
    return  Song(
      title: "",
      artist:"",
      albumId:0,
      path:"",
      albumName:"",
      dateModified: DateTime.now(),
    );
  }


}
