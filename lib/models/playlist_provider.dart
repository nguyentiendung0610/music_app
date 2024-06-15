import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  Playlist currentPlaylist = defaultPlaylist;

  Playlist flagPlaylist = defaultPlaylist;

  List<Playlist> personalPlaylists = [defaultPlaylist, Playlist1, Playlist2];

  void createPersonalPlaylist(String name, List<Song> songs) {
    Playlist newPersonalPlaylist = Playlist.createPlaylist(name, songs);
    personalPlaylists.add(newPersonalPlaylist);
  }

  void changeCurrenPlaylist(Playlist playlist) {
    if (personalPlaylists.contains(playlist)) {
      currentPlaylist = playlist;
      _currentSongIndex = 0;
      pause();
      notifyListeners();
    }
  }
  void addSongsToCurrentPlaylist(List<Song> songs) {
    currentPlaylist.songs = List.from(songs);
  }

  /* 
  
  A U D I O P L A Y E R S 
  
  */

  //audio player

  final AudioPlayer _audioPlayer = AudioPlayer();

  //duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isLooping = false;


  bool isPlaylistEmty(Playlist playlist) {
    if (playlist.songs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
  //play the song
  void play() async {
    final String path = currentPlaylist.songs[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying == true) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_isLooping) {
        // Lặp lại bài hát hiện tại
        play();
        // Không tăng chỉ số bài hát
        _currentSongIndex = _currentSongIndex;
      } else if (_isShuffled) {
        // Nếu đang trong chế độ xáo trộn, chọn một bài hát ngẫu nhiên khác
        final random = Random();
        int nextIndex = _currentSongIndex!;
        while (nextIndex == _currentSongIndex) {
          nextIndex = random.nextInt(currentPlaylist.songs.length);
        }
        currentSongIndex = nextIndex;
      } else {
        // Chế độ phát thông thường
        if (_currentSongIndex! < currentPlaylist.songs.length - 1) {
          currentSongIndex = _currentSongIndex! + 1;
        } else {
          currentSongIndex = 0;
        }
      }
    }
  }

  //play previous song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_isLooping) {
        // Lặp lại bài hát hiện tại
        play();
        // Không tăng chỉ số bài hát
        _currentSongIndex = _currentSongIndex;
      } else {
        if (_currentSongIndex! > 0) {
          currentSongIndex = _currentSongIndex! - 1;
        } else {
          currentSongIndex =
              currentPlaylist.songs.length - 1; // Lặp lại từ bài hát cuối cùng
        }
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    //current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //shuffle
  void playShuffled() {
    flagPlaylist = currentPlaylist;
    if (!_isShuffled) {
      int currentIndex = _currentSongIndex!;
      Song song = currentPlaylist.songs[currentIndex];
      currentPlaylist.songs.removeAt(currentIndex);
      currentPlaylist.songs.shuffle();
      currentPlaylist.songs.insert(currentIndex, song);
      _isShuffled = true;
    } else {
      currentPlaylist.songs.clear();
      currentPlaylist.songs = List.from(flagPlaylist.songs);
      _isShuffled = false;
    }
    notifyListeners();
  }

  List<Song> getPlayList() {
    return currentPlaylist.songs;
  }

  void addToPersionalPlaylist(List playlistName, Song song) {
    playlistName.add(song);
  }

  //GETTER SETTER

  int? _currentSongIndex;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;

  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  bool get isShuffled => _isShuffled;
  bool get isLooping => _isLooping;

  set isShuffled(bool value) {
    _isShuffled = value;
    notifyListeners();
  }

  set isLooping(bool value) {
    _isLooping = value;
    notifyListeners();
  }

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
