import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/screens/music_player/handler/audio_handler.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_event.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_state.dart';
import 'package:innershakti_assignment/screens/music_player/model/song.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final List<Song> playlist;
  final AudioHandler _audioHandler = AudioHandler();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _bufferingSubscription;
  StreamSubscription? _bufferedPositionSubscription;

  MusicBloc({required this.playlist}) : super(MusicInitial()) {
    on<InitializePlayer>(_onInitializePlayer);
    on<PlayMusic>(_onPlayMusic);
    on<PauseMusic>(_onPauseMusic);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
    on<SeekMusic>(_onSeekMusic);
    on<UpdatePosition>(_onUpdatePosition);
    on<UpdateDuration>(_onUpdateDuration);
     on<ForwardMusic>(_onForwardMusic);
    on<RewindMusic>(_onRewindMusic);
    on<UpdateBufferedPosition>(_onUpdateBufferedPosition);

    _initialize();
    _audioHandler.onTrackComplete = () {
      add(NextSong());
    };

     _bufferingSubscription = _audioHandler.bufferingStream.listen(
      (isBuffering) => emit(state is MusicPlaying
        ? MusicPlaying(
          isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: state.currentPosition,
            totalDuration: state.totalDuration,
            bufferedPosition: state.bufferedPosition,
            isBuffering: isBuffering,
          )
        : MusicPaused(
          isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: state.currentPosition,
            totalDuration: state.totalDuration,
            bufferedPosition: state.bufferedPosition,
            isBuffering: isBuffering,
          ))
    );
    
    _bufferedPositionSubscription = _audioHandler.bufferedPositionStream.listen(
      (position) => add(UpdateBufferedPosition(position))
    );
  }

  String? _getNextSongUrl(int currentIndex) {
    final nextIndex = (currentIndex + 1) % playlist.length;
    return playlist[nextIndex].url;
  }

  Future<void> _initialize() async {
    await _audioHandler.init();

    // Listen to position changes
    _positionSubscription = _audioHandler.positionStream.listen(
        (position) => add(UpdatePosition(position.inSeconds.toDouble())));

    // Listen to duration changes
    _durationSubscription = _audioHandler.durationStream.listen((duration) {
      if (duration != null) {
        add(UpdateDuration(duration.inSeconds.toDouble()));
      }
    });

    // Listen to playing state changes
    _playingSubscription = _audioHandler.playingStream.listen(
        (isPlaying) => isPlaying ? add(PlayMusic()) : add(PauseMusic()));

    // Initialize with first song
    add(InitializePlayer());
  }

  Future<void> _onInitializePlayer(
    InitializePlayer event,
    Emitter<MusicState> emit,
  ) async {
    try {
      await _audioHandler.setUrl(
        playlist[state.currentIndex].url,
        preloadNextUrl: _getNextSongUrl(state.currentIndex),
      );
      emit(MusicPaused(
        isLoading: false,
        currentIndex: state.currentIndex,
        currentPosition: 0.0,
        totalDuration: state.totalDuration,
        bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
      ));
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<void> _onPlayMusic(PlayMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioHandler.play();
      emit(MusicPlaying(
        isLoading: false,
        currentIndex: state.currentIndex,
        currentPosition: state.currentPosition,
        totalDuration: state.totalDuration,
        bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
      ));
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> _onPauseMusic(PauseMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioHandler.pause();
      emit(MusicPaused(
        isLoading: false,
        currentIndex: state.currentIndex,
        currentPosition: state.currentPosition,
        totalDuration: state.totalDuration,
        bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
      ));
    } catch (e) {
      print('Error pausing music: $e');
    }
  }

  Future<void> _onNextSong(NextSong event, Emitter<MusicState> emit) async {
    try {
      // Emit loading state but maintain playing state
      emit(state is MusicPlaying
          ? MusicPlaying(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: true,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            )
          : MusicPaused(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: true,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            ));

      final nextIndex = (state.currentIndex + 1);

      await _audioHandler.setUrl(playlist[nextIndex].url);
      await _audioHandler.play();

      // Emit new state with loading complete
      emit(MusicPlaying(
        currentIndex: nextIndex,
        currentPosition: 0.0,
        totalDuration: state.totalDuration,
        isLoading: false,
        bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
      ));
    } catch (e) {
      print('Error playing next song: $e');
      // Emit error state but maintain playability
      emit(state is MusicPlaying
          ? MusicPlaying(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: false,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            )
          : MusicPaused(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: false,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            ));
    }
  }

  Future<void> _onPreviousSong(
      PreviousSong event, Emitter<MusicState> emit) async {
    try {
      // Emit loading state but maintain playing state
      emit(state is MusicPlaying
          ? MusicPlaying(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: true,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            )
          : MusicPaused(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: true,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            ));

      final previousIndex =
          state.currentIndex > 0 ? state.currentIndex - 1 : playlist.length - 1;

      await _audioHandler.setUrl(playlist[previousIndex].url);
      await _audioHandler.play();

      // Emit new state with loading complete
      emit(MusicPlaying(
        currentIndex: previousIndex,
        currentPosition: 0.0,
        totalDuration: state.totalDuration,
        isLoading: false,
        bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
      ));
    } catch (e) {
      print('Error playing previous song: $e');
      // Emit error state but maintain playability
      emit(state is MusicPlaying
          ? MusicPlaying(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: false,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            )
          : MusicPaused(
              currentIndex: state.currentIndex,
              currentPosition: state.currentPosition,
              totalDuration: state.totalDuration,
              isLoading: false,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            ));
    }
  }

  Future<void> _onSeekMusic(SeekMusic event, Emitter<MusicState> emit) async {
    try {
      await _audioHandler.seek(Duration(seconds: event.position.toInt()));
      emit(state is MusicPlaying
          ? MusicPlaying(
              isLoading: false,
              currentIndex: state.currentIndex,
              currentPosition: event.position,
              totalDuration: state.totalDuration,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            )
          : MusicPaused(
              isLoading: false,
              currentIndex: state.currentIndex,
              currentPosition: event.position,
              totalDuration: state.totalDuration,
              bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
            ));
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<MusicState> emit) {
    emit(state is MusicPlaying
        ? MusicPlaying(
            isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: event.position,
            totalDuration: state.totalDuration,
            bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
          )
        : MusicPaused(
            isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: event.position,
            totalDuration: state.totalDuration,
            bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
          ));
  }

  void _onUpdateDuration(UpdateDuration event, Emitter<MusicState> emit) {
    emit(state is MusicPlaying
        ? MusicPlaying(
            isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: state.currentPosition,
            totalDuration: event.duration,
            bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
          )
        : MusicPaused(
            isLoading: false,
            currentIndex: state.currentIndex,
            currentPosition: state.currentPosition,
            totalDuration: event.duration,
            bufferedPosition: state.bufferedPosition,
        isBuffering: state.isBuffering
          ));
  }


  Future<void> _onForwardMusic(
    ForwardMusic event,
    Emitter<MusicState> emit,
  ) async {
    await _audioHandler.forward(event.seconds);
  }
  
  Future<void> _onRewindMusic(
    RewindMusic event,
    Emitter<MusicState> emit,
  ) async {
    await _audioHandler.rewind(event.seconds);
  }
  
  void _onUpdateBufferedPosition(
    UpdateBufferedPosition event,
    Emitter<MusicState> emit,
  ) {
    emit(state is MusicPlaying
      ? MusicPlaying(
        isLoading: false,
          currentIndex: state.currentIndex,
          currentPosition: state.currentPosition,
          totalDuration: state.totalDuration,
          bufferedPosition: event.buffered.inSeconds.toDouble(),
          isBuffering: state.isBuffering,
        )
      : MusicPaused(
        isLoading: false,
          currentIndex: state.currentIndex,
          currentPosition: state.currentPosition,
          totalDuration: state.totalDuration,
          bufferedPosition: event.buffered.inSeconds.toDouble(),
          isBuffering: state.isBuffering,
        ));
  }

  

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playingSubscription?.cancel();
     _bufferingSubscription?.cancel();
    _bufferedPositionSubscription?.cancel();
    _audioHandler.dispose();
    return super.close();
  }
}
