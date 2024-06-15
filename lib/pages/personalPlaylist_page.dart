import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:provider/provider.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/playlist_provider.dart';

class PersonalPlayListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy danh sách personal playlists từ PlaylistProvider
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    void showCreatePlaylistDialog(BuildContext context, Playlist playlist) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('CREATE PLAYLIST'),
            content: TextField(
              onChanged: (value) {
                playlist.playlistName = value;
              },
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Xử lý logic tạo playlist mới
                  if (playlist.playlistName.isNotEmpty) {
                    playlistProvider.personalPlaylists.add(playlist);
                    Navigator.of(context).pop();
                  }
                  ;
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      );
    }

    void _showDeleteConfirmationDialog(Playlist playlist) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xóa Playlist'),
            content: Text('Bạn muốn xóa playlist: ${playlist.playlistName}?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Xử lý xóa playlist
                  playlistProvider.personalPlaylists.removeWhere((element) =>
                      element.playlistName == playlist.playlistName);
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PERSONAL PLAYLIST'),
      ),
      body: ListView.builder(
        itemCount: playlistProvider.personalPlaylists.length,
        itemBuilder: (context, index) {
          final playlist = playlistProvider.personalPlaylists[index];
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(playlist.playlistName),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _showDeleteConfirmationDialog(playlist);
                  },
                ),
              ],
            ),
            onTap: () {
              playlistProvider.changeCurrenPlaylist(playlist);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistPage(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Playlist playlist = Playlist(playlistName: " ", songs: []);
          showCreatePlaylistDialog(context, playlist);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
