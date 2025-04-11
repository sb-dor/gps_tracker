import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

class LocationTrackerHelper {
  LocationTrackerHelper(this._location, this._deviceInfoPlugin);

  final Location _location;
  final DeviceInfoPlugin _deviceInfoPlugin;

  double calculateDistance(lat1, lon1, lat2, lon2, {bool inMeters = true}) {
    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    if (inMeters) {
      return 12742 * 1000 * asin(sqrt(a)); // 12742 km is Earth's diameter -> * 1000 = meters
    } else {
      return 12742 * asin(sqrt(a)); // in km
    }
  }

  ({bool isValid, DateTime? positionDateTime, double? distance}) isValidPosition(
    LocationData currentPosition,
    LocationData? lastValidPosition,
  ) {
    // rejecting positions with bad accuracy (over 20) meters). That’s good for consistency.
    // The accuracy is not available on all devices. In these cases the value is 0.0.
    if ((currentPosition.accuracy ?? 0.0) > 50) {
      return (isValid: false, positionDateTime: null, distance: null);
    }

    if (lastValidPosition != null) {
      final currentAndVerifiedPositionsData = dataBetweenTwoPositions(
        freshPosition: currentPosition,
        lastLocation: lastValidPosition,
      );
      // if user's previous location is around 10m do not get that location
      if (currentAndVerifiedPositionsData.distance < 10) {
        return (isValid: false, positionDateTime: null, distance: null);
      }

      return (
        isValid: true,
        positionDateTime: currentAndVerifiedPositionsData.positionDatetime,
        distance: currentAndVerifiedPositionsData.distance,
      );
    }

    return (isValid: true, positionDateTime: null, distance: null);
  }

  ({double speed, double distance, DateTime positionDatetime}) dataBetweenTwoPositions({
    required LocationData freshPosition,
    required LocationData lastLocation,
  }) {
    double distance = calculateDistance(
      freshPosition.latitude,
      freshPosition.longitude,
      lastLocation.latitude,
      lastLocation.longitude,
    );

    final DateTime currentTime = parsedDateTimeFromSinceEpoch(freshPosition.time!.toInt());
    final DateTime lastTime = parsedDateTimeFromSinceEpoch(lastLocation.time!.toInt());

    // Unfortunately, the geoLocator package doesn’t tell you whether the timestamp came from the
    // GPS signal or the device clock — it just gives you the best available timestamp.
    // but it's giving normal
    double timeDiff = currentTime.difference(lastTime).inSeconds.toDouble();

    double speed = (timeDiff > 0) ? (distance / timeDiff) : 0;
    print(
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

  Future<bool> checkPermission() async {
    final permissionResult = await _requestPermission();

    if (!permissionResult) return false;

    if (!(await _location.isBackgroundModeEnabled())) {
      await _location.enableBackgroundMode();
    }

    return true;
  }

  Future<bool> _requestPermission() async {
    int androidSdk = 0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      androidSdk = androidInfo.version.sdkInt;
    }

    bool serviceEnabled = await _location.serviceEnabled();
    while (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    // Foreground location permission
    var permission = await _location.hasPermission();

    while (permission != PermissionStatus.granted) {
      permission = await _location.requestPermission();
    }

    // // Background location
    if (defaultTargetPlatform == TargetPlatform.android) {
      final bgStatus = await permissions.Permission.locationAlways.status;
      if (!bgStatus.isGranted) {
        final result = await permissions.Permission.locationAlways.request();
        if (!result.isGranted) {
          // FROM DOCS: The Android 11 option to always allow is not presented on the location
          // permission dialog prompt. The user has to enable it manually from the app settings.
          if (androidSdk == 30) await permissions.openAppSettings();
          return false;
        }
      }
    }

    // Bluetooth ON check
    // For better location accuracy
    if (defaultTargetPlatform == TargetPlatform.android && androidSdk >= 23) {
      final bluetoothState = await FlutterBluePlus.isOn;
      if (!bluetoothState) {
        // await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
        // return false;
      }
    }

    // iOS location permission (just to be safe)
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final locationStatus = await permissions.Permission.locationAlways.status;
      print("locationStatus of ios: $locationStatus");
      if (!locationStatus.isGranted) {
        final result = await permissions.Permission.locationAlways.request();
        print("result of ios: $result");
        if (!result.isGranted) {
          await permissions.openAppSettings();
          return false;
        }
      }
    }

    return true;
  }
}
