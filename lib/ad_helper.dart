import 'dart:io';

// class AdHelper {
//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/4411468910";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9924432279679989/8478297575';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9924432279679989/8478297575';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
