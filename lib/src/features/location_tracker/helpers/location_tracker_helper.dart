import 'dart:math';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracker/src/common/constants/location_tracker_message_constants.dart';
import 'package:gps_tracker/src/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:location/location.dart';
import 'dart:developer' as dev;
import 'package:permission_handler/permission_handler.dart' as permissions;

class LocationTrackerHelper {
  LocationTrackerHelper(this._location, this._deviceInfoPlugin);

  final Location _location;
  final DeviceInfoPlugin _deviceInfoPlugin;

  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2, {
    bool inMeters = true,
  }) {
    final p = 0.017453292519943295;
    final c = cos;
    final a =
        0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    if (inMeters) {
      return 12742 * 1000 * asin(sqrt(a)); // 12742 km is Earth's diameter -> * 1000 = meters
    } else {
      return 12742 * asin(sqrt(a)); // in km
    }
  }

  ({bool isValid, DateTime? positionDateTime, double? distance, double? speed}) isValidPosition(
    LocationData currentPosition,
    LocationData? lastValidPosition,
  ) {
    // rejecting positions with bad accuracy (over 30) meters). That’s good for consistency.
    // The accuracy is not available on all devices. In these cases the value is 0.0.
    if ((currentPosition.accuracy ?? 0.0) > 30) {
      return (isValid: false, positionDateTime: null, distance: null, speed: null);
    }

    if (lastValidPosition != null) {
      final currentAndVerifiedPositionsData = dataBetweenTwoPositions(
        freshPosition: currentPosition,
        lastLocation: lastValidPosition,
      );
      // if user's previous location is around 10m do not get that location
      if (currentAndVerifiedPositionsData.distance < 10) {
        return (isValid: false, positionDateTime: null, distance: null, speed: null);
      }

      // // 100 km/h
      // if (currentAndVerifiedPositionsData.speed > 27.78) {
      //   return (isValid: false, positionDateTime: null, distance: null, speed: null);
      // }

      // If the vehicle drives more than 1 km in 10 seconds, return false.
      if (currentAndVerifiedPositionsData.distance > 1000) {
        return (isValid: false, positionDateTime: null, distance: null, speed: null);
      }

      return (
        isValid: true,
        positionDateTime: currentAndVerifiedPositionsData.positionDatetime,
        distance: currentAndVerifiedPositionsData.distance,
        speed: currentAndVerifiedPositionsData.speed,
      );
    }

    return (isValid: true, positionDateTime: null, distance: null, speed: null);
  }

  ({double speed, double distance, DateTime positionDatetime}) dataBetweenTwoPositions({
    required LocationData freshPosition,
    required LocationData lastLocation,
  }) {
    final double distance = calculateDistance(
      freshPosition.latitude!,
      freshPosition.longitude!,
      lastLocation.latitude!,
      lastLocation.longitude!,
    );

    final DateTime currentTime = parsedDateTimeFromSinceEpoch(freshPosition.time!.toInt());
    final DateTime lastTime = parsedDateTimeFromSinceEpoch(lastLocation.time!.toInt());

    final double timeDiff = currentTime.difference(lastTime).inSeconds.toDouble();

    final double speed = (timeDiff > 0) ? (distance / timeDiff) : 0;
    dev.log(
      "current_datetime parsed: $currentTime\n"
      "last_datetime parsed: $lastTime\n"
      "diff: $timeDiff\n"
      "speed: $speed\n"
      "distance: $distance",
    );
    // print("distance: $distance | speed: $speed | timeDif: $timeDiff");
    return (speed: speed, distance: distance, positionDatetime: currentTime);
  }

  DateTime parsedDateTimeFromSinceEpoch(int time) => DateTime.fromMillisecondsSinceEpoch(time);

  bool get _isMobilePlatform =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<bool> checkPermission({
    required FutureVoidCallback locationNotificationDialog,
    void Function(String message)? onErrorMessage,
  }) async {
    try {
      if (kIsWeb || kIsWasm) return true;

      final permissionGranted = await _requestPermission(
        locationNotificationDialog: locationNotificationDialog,
      );

      if (!permissionGranted) return false;

      if (_isMobilePlatform && !(await _location.isBackgroundModeEnabled())) {
        await _location.enableBackgroundMode();
      }

      return true;
    } on PlatformException {
      onErrorMessage?.call(LocationTrackerMessageConstants.platformExceptionError);
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<bool> _requestPermission({required FutureVoidCallback locationNotificationDialog}) async {
    if (!await _checkServiceEnables()) return false;

    var shownTransparencyDialog = false;

    if (defaultTargetPlatform == TargetPlatform.iOS &&
        !(await _handleAppTransparency(
          locationNotificationDialog,
          () => shownTransparencyDialog = true,
        ))) {
      return false;
    }

    final locationPermission = await _requestLocationPermission(
      locationNotificationDialog,
      shownTransparencyDialog,
    );

    if (!locationPermission) {
      return false;
    }

    if (defaultTargetPlatform == TargetPlatform.android &&
        !await _checkAndroidLocationAlwaysPermission()) {
      await permissions.openAppSettings();
      return false;
    }

    return true;
  }

  Future<bool> _handleAppTransparency(
    FutureVoidCallback dialog,
    VoidCallback markDialogShown,
  ) async {
    var status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notSupported) return true;

    if (status == TrackingStatus.restricted || status == TrackingStatus.denied) {
      markDialogShown();
      await dialog();
      await permissions.openAppSettings();
      return false;
    }

    while (status == TrackingStatus.notDetermined) {
      markDialogShown();
      await dialog();
      status = await AppTrackingTransparency.requestTrackingAuthorization();
    }

    return status == TrackingStatus.authorized;
  }

  Future<bool> _requestLocationPermission(
    FutureVoidCallback dialog,
    bool dialogAlreadyShown,
  ) async {
    var permission = await _location.hasPermission();

    if (permission == PermissionStatus.granted) return true;

    if (!dialogAlreadyShown) await dialog();

    permission = await _location.requestPermission();

    if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
      await permissions.openAppSettings();
      return false;
    }

    return true;
  }

  Future<bool> _checkAndroidLocationAlwaysPermission() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    if (androidInfo.version.sdkInt >= 30) {
      return await permissions.Permission.locationAlways.isGranted;
    }
    return true;
  }

  // PlatformException(SERVICE_STATUS_ERROR, Location service status couldn't be determined, null, null)
  // for solution you can check the url that I put in readme.md file
  // in main app folder
  Future<bool> _checkServiceEnables({int limit = 10}) async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        return false;
      }

      return true;
    } on PlatformException {
      await Future.delayed(Duration(milliseconds: 100));
      if (limit > 0) {
        return await _checkServiceEnables(limit: --limit);
      }
    }
    return false;
  }
}
