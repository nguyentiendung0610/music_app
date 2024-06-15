import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PlaylistProvider playlistProvider;
  late bool isSongPlaying = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Consumer<PlaylistProvider>(
          builder: (context, playlistProvider, _) {
            return Text(playlistProvider.currentPlaylist.playlistName.toUpperCase());
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
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = playlistProvider.currentPlaylist.songs;
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
      ),
    );
  }
}