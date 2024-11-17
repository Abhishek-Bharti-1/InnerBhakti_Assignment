import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioHandler {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer _nextPlayer = AudioPlayer();
  bool _isPreloading = false;
  
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    // Handle completion to auto-advance
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        onTrackComplete?.call();
      }
    });
  }
  
  Function? onTrackComplete;
  
  Future<void> setUrl(String url, {String? preloadNextUrl}) async {
    // Load the current track
    await _audioPlayer.setUrl(url);
    
    // Preload next track if provided
    if (preloadNextUrl != null) {
      _preloadNext(preloadNextUrl);
    }
  }
  
  Future<void> _preloadNext(String url) async {
    try {
      _isPreloading = true;
      await _nextPlayer.setUrl(url);
      _isPreloading = false;
    } catch (e) {
      print('Error preloading next track: $e');
      _isPreloading = false;
    }
  }
  
  Future<void> switchToPreloadedTrack({String? preloadNextUrl}) async {
    if (_isPreloading) {
      await Future.delayed(Duration(milliseconds: 100));
      return switchToPreloadedTrack(preloadNextUrl: preloadNextUrl);
    }
    
    // Swap players
    final tempPlayer = _audioPlayer;
    await tempPlayer.pause();
    
    _audioPlayer = _nextPlayer;
    _nextPlayer = tempPlayer;
    
    await _audioPlayer.play();
    
    // Preload next track if provided
    if (preloadNextUrl != null) {
      _preloadNext(preloadNextUrl);
    }
  }
  
  Future<void> play() async {
    await _audioPlayer.play();
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _nextPlayer.stop();
  }
  
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;
  Stream<Duration> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<bool> get bufferingStream => _audioPlayer.processingStateStream
    .map((state) => state == ProcessingState.buffering);

   Future<void> forward(int seconds) async {
    final currentPosition = await _audioPlayer.position;
    final duration = await _audioPlayer.duration;
    if (duration == null) return;
    
    final newPosition = currentPosition + Duration(seconds: seconds);
    if (newPosition < duration) {
      await _audioPlayer.seek(newPosition);
    } else {
      await _audioPlayer.seek(duration);
    }
  }
  
  Future<void> rewind(int seconds) async {
    final currentPosition = await _audioPlayer.position;
    
    final newPosition = currentPosition - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      await _audioPlayer.seek(newPosition);
    } else {
      await _audioPlayer.seek(Duration.zero);
    }
  }
  
  
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _nextPlayer.dispose();
  }
}
