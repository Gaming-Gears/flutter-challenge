import 'package:flame_audio/flame_audio.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal() {
    // Initialize with default volume levels
    setBgmVolume(_bgmVolume);
    setSfxVolume(_sfxVolume);
  }

  double _bgmVolume = 0.5; // Default background music volume
  double _sfxVolume = 0.5; // Default sound effects volume

  // Adjusting the volume for background music
  void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0); // Ensure volume is between 0 and 1
    FlameAudio.bgm.audioPlayer.setVolume(_bgmVolume);
  }

  // Getting the current background music volume
  double getBgmVolume() => _bgmVolume;

  // Adjusting the volume for sound effects
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0); // Ensure volume is between 0 and 1
    final loadedFiles = FlameAudio.audioCache.loadedFiles;
    loadedFiles.forEach((key, value) {
      FlameAudio.play(key, volume: _sfxVolume);
    });
  }

  // Getting the current sound effects volume
  double getSfxVolume() => _sfxVolume;

  // Playing background music with current volume
  void playBgm(String filename) {
    FlameAudio.bgm.play(filename, volume: _bgmVolume);
  }

  // Stopping background music
  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  // Pausing background music
  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  // Resuming background music
  void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  // Playing a sound effect with current volume
  void playSfx(String filename) {
    FlameAudio.play(filename, volume: _sfxVolume);
  }

  // Stopping all sound effects
  // Note: Flame does not directly support stopping individual sound effects
  // that have been started with FlameAudio.play. This method stops all sounds
  // played through the audioCache's fixed player, which might not be suitable
  // for all use cases.
  void stopSfx() {
    final loadedFiles = FlameAudio.audioCache.loadedFiles;
    loadedFiles.forEach((key, value) {
      FlameAudio.play(key, volume: 0.0);
    });
  }

  // Preloading audio files
  void preloadAudioFiles(List<String> files) {
    files.forEach(FlameAudio.audioCache.load);
  }
}
