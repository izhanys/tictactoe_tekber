import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  late AudioPlayer _audioPlayer;

  // Private constructor
  AudioService._internal() {
    _audioPlayer = AudioPlayer();
  }

  // Factory constructor to return singleton instance
  factory AudioService() {
    return _instance;
  }

  /// Play a sound effect
  /// [soundName] - name of the sound file without extension (e.g., 'tap', 'win', 'lose')
  Future<void> playSound(String soundName) async {
    try {
      print('📢 Playing sound: $soundName');
      
      // Stop any currently playing sound first
      await _audioPlayer.stop();
      
      // Play the new sound
      await _audioPlayer.play(
        AssetSource('sounds/$soundName.mp3'),
        volume: 0.8,
      );
      
      print('✓ Sound $soundName played');
    } catch (e) {
      print('❌ Error playing sound $soundName: $e');
    }
  }

  /// Stop the current sound
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Dispose of the audio player
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }
}
