import 'package:flutter/material.dart';
import 'package:music_app/components/neu_box.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  //convert duration into min:sec
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  String imagePath(Song song) {
    return song.albumArtImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get playlist
        final currentPlaylist = value.currentPlaylist;
        //get current song
        Song currentSong = currentPlaylist.songs[value.currentSongIndex ?? 0];
        //return scaffold UI
        return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //app bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //back button
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),

                        // title
                        Text(currentPlaylist.playlistName),

                        //menu button
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    //album artwork
                    NeuBox(
                      child: Column(
                        children: [
                          //image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(currentSong.albumArtImagePath),
                          ),

                          //Song and artis name and icon
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //song and artis name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(currentSong.artistName),
                                  ],
                                ),

                                // heart icon
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    //song duration progress
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //start time
                              Text(formatTime(value.currentDuration)),

                              //shuffle icon
                              GestureDetector(
                                onTap: () {
                                  value.playShuffled();
                                },
                                child: Icon(
                                  value.isShuffled
                                      ? Icons.shuffle_on
                                      : Icons.shuffle,
                                ),
                              ),

                              //repeat icon
                              GestureDetector(
                                onTap: () {
                                  value.isLooping = !value.isLooping;
                                },
                                child: Icon(
                                  value.isLooping
                                      ? Icons.repeat_on
                                      : Icons.repeat,
                                ),
                              ),

                              //end time
                              Text(formatTime(value.totalDuration))
                            ],
                          ),
                        ),

                        //song duration progress
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0),
                          ),
                          child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds.toDouble(),
                            activeColor: Colors.green,
                            onChanged: (double double) {},
                            onChangeEnd: (double double) {
                              value.seek(Duration(seconds: double.toInt()));
                            },
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //playback controls
                    Row(
                      children: [
                        //skip previous
                        Expanded(
                          child: GestureDetector(
                            onTap: value.playPreviousSong,
                            child: const NeuBox(
                              child: Icon(
                                Icons.skip_previous,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        //play pause
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: value.pauseOrResume,
                            child: NeuBox(
                              child: Icon(value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                          ),
                        ),
                        //skip forward

                        const SizedBox(width: 20),

                        Expanded(
                          child: GestureDetector(
                            onTap: value.playNextSong,
                            child: const NeuBox(
                              child: Icon(
                                Icons.skip_next,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
