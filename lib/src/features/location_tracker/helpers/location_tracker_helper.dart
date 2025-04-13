import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracker/src/common/constants/location_tracker_message_constants.dart';
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
    // rejecting positions with bad accuracy (over 20) meters). That’s good for consistency.
    // The accuracy is not available on all devices. In these cases the value is 0.0.
    if ((currentPosition.accuracy ?? 0.0) > 50) {
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

    // Unfortunately, the geoLocator package doesn’t tell you whether the timestamp came from the
    // GPS signal or the device clock — it just gives you the best available timestamp.
    // but it's giving normal
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

  Future<bool> checkPermission({void Function(String message)? onErrorMessage}) async {
    try {
      if (kIsWeb || kIsWasm) return true;

      final permissionResult = await _requestPermission();

      if (!permissionResult) return false;

      final isMobilePlatform =
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS;

      if (isMobilePlatform && !(await _location.isBackgroundModeEnabled())) {
        await _location.enableBackgroundMode();
      }

      return true;
    } on PlatformException catch (error, stackTrace) {
      if (onErrorMessage != null) {
        onErrorMessage(LocationTrackerMessageConstants.platformExceptionError);
      }
      debugPrint("error is $error | stacktrace: $stackTrace");
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<bool> _requestPermission() async {
    final service = await _checkServiceEnables();

    if (!service) return false;
    // Foreground location permission
    var permission = await _location.hasPermission();

    if (permission != PermissionStatus.granted) {
      debugPrint("is hasPermission: $permission");
      permission = await _location.requestPermission();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        final locationAlways = await permissions.Permission.locationAlways.isGranted;
        if (!locationAlways) {
          await permissions.openAppSettings();
          return false;
        }
      }
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
        debugPrint("is service enables: $serviceEnabled");
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
