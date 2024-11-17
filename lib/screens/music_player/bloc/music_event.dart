abstract class MusicEvent {}

class PlayMusic extends MusicEvent {}
class PauseMusic extends MusicEvent {}
class NextSong extends MusicEvent {}
class PreviousSong extends MusicEvent {}
class SeekMusic extends MusicEvent {
  final double position;
  SeekMusic(this.position);
}
class InitializePlayer extends MusicEvent {}
class UpdatePosition extends MusicEvent {
  final double position;
  UpdatePosition(this.position);
}
class UpdateDuration extends MusicEvent {
  final double duration;
  UpdateDuration(this.duration);
}

class ForwardMusic extends MusicEvent {
  final int seconds;
  ForwardMusic([this.seconds = 10]);
}

class RewindMusic extends MusicEvent {
  final int seconds;
  RewindMusic([this.seconds = 10]);
}

class UpdateBufferedPosition extends MusicEvent {
  final Duration buffered;
  UpdateBufferedPosition(this.buffered);
}