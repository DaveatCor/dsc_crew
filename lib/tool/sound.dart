import 'package:mdw_crew/index.dart';

class SoundUtil {
  
  static Future<void> soundAndVibrate(String soundName) async{
    Vibration.hasVibrator().then((value) async {

      if (value == true) {
        await Vibration.vibrate(duration: 90);
      }
    });

    await FlutterRingtonePlayer.play(
      fromAsset: 'assets/sounds/$soundName',
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIps
    );
  }
}