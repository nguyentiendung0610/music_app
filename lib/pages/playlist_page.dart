import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../models/song.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late PlaylistProvider playlistProvider;
  late bool isSongPlaying = false;
  List<Song> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    setState(() {
      playlistProvider.currentSongIndex = songIndex;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ),
      );
      isSongPlaying = true;
    });
  }

  void showAddSongBottomSheet() {
    List<Song> filteredSongs = defaultPlaylist.songs
        .where((song) => !playlistProvider.currentPlaylist.songs.contains(song))
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: filteredSongs.length,
          itemBuilder: (context, index) {
            final Song song = filteredSongs[index];
            final bool isSelected = selectedSongs.contains(song);

            return ListTile(
              tileColor: isSelected ? Colors.grey[300] : null,
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              leading: Image.asset(song.albumArtImagePath),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSongs.remove(song);
                  } else {
                    selectedSongs.add(song);
                  }
                }
                );
              },
            );
          },
        );
      },
    ).then((value) {
      if (selectedSongs.isNotEmpty) {
        // Thêm các bài hát đã chọn vào currentPlaylist
        playlistProvider.addSongsToCurrentPlaylist(selectedSongs);
        selectedSongs.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Consumer<PlaylistProvider>(
            builder: (context, playlistProvider, _) {
              return Text(
                  playlistProvider.currentPlaylist.playlistName.toUpperCase());
            },
          ),
          actions: [
            if (isSongPlaying)
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SongPage(),
                    ),
                  );
                },
              ),
          ],
        ),
        drawer: const MyDrawer(),
        body: !playlistProvider.isPlaylistEmty(playlistProvider.currentPlaylist)
            ? Consumer<PlaylistProvider>(
                builder: (context, value, child) {
                  final List<Song> playlist =
                      playlistProvider.currentPlaylist.songs;
                  return ListView.builder(
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      final Song song = playlist[index];
                      return ListTile(
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        leading: Image.asset(song.albumArtImagePath),
                        onTap: () => goToSong(index),
                      );
                    },
                  );
                },
                child: ElevatedButton(
                  onPressed: () {
                    showAddSongBottomSheet();
                  },
                  child: Text('Thêm bài hát'),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Danh sách trống'),
                    ElevatedButton(
                      onPressed: () {
                        showAddSongBottomSheet();
                      },
                      child: Text('Thêm bài hát'),
                    ),
                  ],
                ),
              ),
              );
  }
}
