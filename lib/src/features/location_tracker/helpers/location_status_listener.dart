import 'dart:async';
import 'package:gps_tracker/src/features/location_tracker/models/location_types.dart';
import 'location_tracker_helper.dart';

class LocationStatusListener {
  LocationStatusListener({required this.locationTrackerHelper});

  final LocationTrackerHelper locationTrackerHelper;

  Timer? _statusTimer;
  bool _popUpIsShowing = false;

  void listenLocationStatus({
    required FutureVoidCallback locationNotificationDialog,
    required FutureVoidCallback locationNotificationForAppSettings,
    void Function(String message)? onErrorMessage,
  }) {
    try {
      _statusTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
        if (_popUpIsShowing) return;
        // print("is popupShowing or not ?");
        _popUpIsShowing = true;
        await locationTrackerHelper.checkPermission(
          onErrorMessage: onErrorMessage,
          locationNotificationDialog: locationNotificationDialog,
          locationNotificationForAppSettings: locationNotificationForAppSettings,
        );
        _popUpIsShowing = false;
      });
    } catch (error, stackTrace) {
      if (onErrorMessage != null) onErrorMessage("Something went wrong");
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void dispose() {
    _statusTimer?.cancel();
    _popUpIsShowing = false;
  }
}
