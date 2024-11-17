abstract class MusicState {
  final int currentIndex;
  final bool isPlaying;
  final bool isLoading;
  final double currentPosition;
  final double totalDuration;
  final double bufferedPosition;
  final bool isBuffering;

  MusicState({
    required this.currentIndex,
    required this.isPlaying,
    required this.isLoading,
    required this.currentPosition,
    required this.totalDuration,
    this.bufferedPosition = 0.0,
    this.isBuffering = false,
  });
}

class MusicInitial extends MusicState {
  MusicInitial()
      : super(
          currentIndex: 0,
          isPlaying: false,
          isLoading: false,
          currentPosition: 0.0,
          totalDuration: 0.0,
        );
}

class MusicPlaying extends MusicState {
  MusicPlaying({
    required int currentIndex,
    required double currentPosition,
    required double totalDuration,
    required bool isLoading,
    required bool isBuffering,
    required double bufferedPosition
  }) : super(
          currentIndex: currentIndex,
          isPlaying: true,
          isLoading: isLoading,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          isBuffering: isBuffering,
          bufferedPosition: bufferedPosition
        );
}

class MusicPaused extends MusicState {
  MusicPaused({
    required int currentIndex,
    required double currentPosition,
    required double totalDuration,
    required bool isLoading,
    required bool isBuffering,
    required double bufferedPosition
  }) : super(
          currentIndex: currentIndex,
          isPlaying: false,
          isLoading: isLoading,
          currentPosition: currentPosition,
          totalDuration: totalDuration,
          isBuffering: isBuffering,
          bufferedPosition: bufferedPosition
        );
}
