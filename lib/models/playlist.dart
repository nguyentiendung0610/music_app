import 'package:music_app/models/song.dart';

class Playlist {
  String playlistName;
  List<Song> songs;

  Playlist({
    required this.playlistName,
    this.songs = const [],
  });

  static Playlist createPlaylist(String name, List<Song> songs) {
    return Playlist(playlistName: name, songs: songs);
  }

}

Playlist defaultPlaylist = Playlist(playlistName: "Playlizy", songs: songs);
Playlist Playlist1 = Playlist(playlistName: "Playlist1", songs: song1);
Playlist Playlist2 = Playlist(playlistName: "Playlist2", songs: song2);