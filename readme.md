Take a look at these issues on GitHub., 
there is a discussion about gps, which does not work properly if there is no clear view to the sky (satellite)


https://stackoverflow.com/a/77103201/18451446

https://github.com/Baseflow/flutter-geolocator/issues/1312

https://github.com/Baseflow/flutter-geolocator/issues/1312#issuecomment-1697401259

https://github.com/Baseflow/flutter-geolocator/issues/1312#issuecomment-1706290915


for ios problems:

https://stackoverflow.com/questions/67870103/cant-retrieve-location-in-flutter-by-geolocator

https://stackoverflow.com/questions/62749900/flutter-location-packages-does-not-return-current-location-on-ios

problems with android 9 only (haven't checked on real device), discussion on github about the same 
problem but with difference package:

https://github.com/Baseflow/flutter-geolocator/issues/1369


problems with android 11 and higher

https://developer.android.com/develop/sensors-and-location/location/permissions/background

https://developer.android.com/develop/sensors-and-location/location/permissions/background#background-dialog-target-sdk-version


about -> SERVICE_STATUS_ERROR in android

https://github.com/Lyokone/flutterlocation/issues/568

-------------------------------------
# 🛰️ GPS Tracking App

A cross-platform GPS tracking application built with Flutter. It allows users to track their location in real time and view their position on a map. The app also supports background location tracking.

## ✅ Features

- Real-time GPS tracking
- Background tracking support
- Integrated map view using [`flutter_map`](https://pub.dev/packages/flutter_map)
- Cross-platform support
- Built with the [`location`](https://pub.dev/packages/location) package
- Solved false "jump" location issue by filtering inaccurate or unrealistic coordinates

## 📱 Platform Support

| Platform | Status       |
|----------|--------------|
| ✅ Android | Implemented |
| ✅ iOS     | Implemented |
| ⬜ macOS   | Not yet      |
| ⬜ Web     | Not yet      |

## 🗺️ Map Integration

A minimal implementation of [`flutter_map`](https://pub.dev/packages/flutter_map) allows users to see their current location on the map.

## 🛠️ Background Mode

Location tracking continues to work even when the app is in the background (Android and iOS).

---

### *Made with Flutter 💙*

<p align="left">
  <img src="https://raw.githubusercontent.com/sb-dor/gps_tracker/refs/heads/main/assets/readme_pics/ios_simulator_pic.png" width="150" />
  <img src="https://raw.githubusercontent.com/sb-dor/gps_tracker/refs/heads/main/assets/readme_pics/android_simulator.png" width="150" />
</p>