import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_bloc.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_event.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_state.dart';
import 'package:innershakti_assignment/screens/music_player/model/song.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String imageUrl;

  const MusicPlayerScreen({super.key, required this.imageUrl});

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late MusicBloc _musicBloc;
  final List<Song> playlist = [
    Song(
        id: '1',
        title: 'What is Focus?',
        artist: 'John Doe',
        duration: '3:45',
        url:
            'https://firebasestorage.googleapis.com/v0/b/mess-maven-demo.appspot.com/o/ethereal-vistas-191254.mp3?alt=media&token=8bfe88ea-e8e7-404b-bb55-3868048dfb82'),
    Song(
        id: '2',
        title: 'Why Focus Matters?',
        artist: 'John Doe',
        duration: '4:20',
        url:
            'https://firebasestorage.googleapis.com/v0/b/mess-maven-demo.appspot.com/o/groovy-ambient-funk-201745.mp3?alt=media&token=3d870b2a-a854-439b-b854-850a842db17f'),
    //
    Song(
        id: '3',
        title: 'Deep Work Methods',
        artist: 'John Doe',
        duration: '3:45',
        url:
            'https://firebasestorage.googleapis.com/v0/b/mess-maven-demo.appspot.com/o/stylish-deep-electronic-262632.mp3?alt=media&token=a9137cb8-0aca-48d1-b2ae-bc37c86aa130'),
    //Add more songs...
  ];

  late String imageUrl;
  @override
  void initState() {
    super.initState();
    _musicBloc = MusicBloc(playlist: playlist);
    imageUrl = widget.imageUrl;
  }

  @override
  void dispose() {
    _musicBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0x27, 0x2D, 0x32),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Music Player',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocProvider.value(
        value: _musicBloc,
        child: BlocBuilder<MusicBloc, MusicState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Album Art Placeholder
                Container(
                  height: 360,
                  width: 320,
                  
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl), 
                                      fit: BoxFit
                                          .cover, // Makes the image fill the card
                                    ),
                                  ),
                ),
                Column(
                  children: [
                    // Song Info
                    state.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      playlist[state.currentIndex].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      playlist[state.currentIndex].artist,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white54),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share,
                                          size: 30,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.queue_music_rounded,
                                            size: 35, color: Colors.white))
                                  ],
                                ),
                              ],
                            ),
                          ),
                    // Progress Bar
                    Column(
                      children: [
                        Slider(
                          activeColor: Colors.deepPurpleAccent,
                          value: state.currentPosition,
                          max: state.totalDuration,
                          onChanged: (value) {
                            context.read<MusicBloc>().add(SeekMusic(value));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(state.currentPosition),
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(_formatDuration(state.totalDuration),
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.replay_10_sharp, color: Colors.white),
                          iconSize: 32,
                          onPressed: state.isBuffering
                              ? null
                              : () => context
                                  .read<MusicBloc>()
                                  .add(RewindMusic(10)),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_previous, color: Colors.white),
                          iconSize: 48,
                          onPressed: state.isBuffering
                              ? null
                              : () => state.currentIndex != 0
                                  ? context
                                      .read<MusicBloc>()
                                      .add(PreviousSong())
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'This is the first track of the playlist'),
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        duration: Duration(seconds: 2),
                                      ),
                                    ),
                        ),
                        IconButton(
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: Colors.white,
                          ),
                          iconSize: 64,
                          onPressed: state.isBuffering
                              ? null
                              : () => context.read<MusicBloc>().add(
                                    state.isPlaying
                                        ? PauseMusic()
                                        : PlayMusic(),
                                  ),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next, color: Colors.white),
                          iconSize: 48,
                          onPressed: state.isBuffering
                              ? null
                              : () => state.currentIndex != playlist.length - 1
                                  ? context.read<MusicBloc>().add(NextSong())
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'This is the last track of the playlist'),
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        duration: Duration(seconds: 2),
                                      ),
                                    ),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.forward_10_sharp, color: Colors.white),
                          iconSize: 32,
                          onPressed: state.isBuffering
                              ? null
                              : () => context
                                  .read<MusicBloc>()
                                  .add(ForwardMusic(10)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).toInt());
    final minutes = duration.inMinutes;
    final remainingSeconds =
        (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}
