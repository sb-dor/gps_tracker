import 'package:flutter/foundation.dart';

class LocationTrackerWidgetController with ChangeNotifier {
  bool isTracking = false;
  bool isStarting = false;
  bool isFinishing = false;
  bool isPausing = false;

  void changeIsTracking(bool value) {
    isTracking = value;
    notifyListeners();
  }

  void changeIsStarting(bool value) {
    isStarting = value;
    notifyListeners();
  }

  void changeIsFinishing(bool value) {
    isFinishing = value;
    notifyListeners();
  }

  void changeIsPausing(bool value) {
    isPausing = value;
    notifyListeners();
  }

  void saveLastInActiveDateTime() async {
    // logic for saving last inactive datetime
    // if user goes to background mode
  }
}
