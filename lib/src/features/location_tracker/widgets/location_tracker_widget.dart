import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gps_tracker/src/common/constants/location_tracker_message_constants.dart';
import 'package:gps_tracker/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:gps_tracker/src/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controllers/location_tracker_widget_controller.dart';

const String mapTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const LatLng locationOfNewYork = LatLng(40.712776, -74.005974);

// THE MAIN LOGIC USAGE
class LocationTrackerWidget extends StatefulWidget {
  const LocationTrackerWidget({super.key});

  @override
  State<LocationTrackerWidget> createState() => LocationTrackerWidgetState();
}

class LocationTrackerWidgetState extends State<LocationTrackerWidget> with WidgetsBindingObserver {
  late final LocationTrackerWidgetController _locationTrackerWidgetController;
  late final LocationTrackerBloc _locationTrackerBloc;
  late final StreamSubscription<LocationTrackerState> _locationTrackerStateSubs;
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locationTrackerWidgetController = LocationTrackerWidgetController();
    _locationTrackerBloc = DependenciesScope.of(context, listen: false).locationTrackerBloc;
    _locationTrackerBloc.add(
      LocationTrackerEvent.initial(
        locationWidgetController: _locationTrackerWidgetController,
        startTracking: startTracking,
        onMessage: _showMessage,
        locationNotificationDialog: _showLocationNotificationPermissionDialog,
        locationNotificationForAppSettings: _showLocationPermissionAppSettingsDialog,
      ),
    );
    _locationTrackerStateSubs = _locationTrackerBloc.stream.listen((state) {
      if (state is LocationTracker$CompletedState &&
          state.locationTrackerStateModel.lastValidPosition != null) {
        _mapController.move(
          LatLng(
            state.locationTrackerStateModel.lastValidPosition!.latitude!,
            state.locationTrackerStateModel.lastValidPosition!.longitude!,
          ),
          _mapController.camera.zoom,
        );
      }
    });
  }

  void startTracking({bool checkIsStarting = true}) {
    if (_locationTrackerWidgetController.isStarting && checkIsStarting) {
      _showMessage("Пожалуйста подождите");
      return;
    }
    _locationTrackerWidgetController.changeIsStarting(true);
    _locationTrackerBloc.add(
      LocationTrackerEvent.start(
        onMessage: _showMessage,
        onStart: () {
          _locationTrackerWidgetController.changeIsTracking(true);
        },
        onFinish: () {
          _locationTrackerWidgetController.changeIsStarting(false);
        },
        locationNotificationDialog: _showLocationNotificationPermissionDialog,
        locationNotificationForAppSettings: _showLocationPermissionAppSettingsDialog,
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showLocationNotificationPermissionDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Разрешение на отслеживание местоположения",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Приложение запрашивает доступ к вашему местоположению для отслеживания во время работы.\n\n"
            "Пожалуйста, разрешите доступ к местоположению, чтобы обеспечить корректную работу функций отслеживания.",
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                elevation: const WidgetStatePropertyAll(0.0),
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Продолжить", style: TextStyle(color: Colors.white)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  Future<void> _showLocationPermissionAppSettingsDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Разрешение на геолокацию'),
            content: const Text(
              'Приложение не сможет работать в полном объёме без доступа к вашему местоположению. '
              'Разрешение необходимо для отслеживания маршрута и корректной работы функций навигации. '
              'Вы можете продолжить использовать другие функции приложения, но работа с геолокацией будет недоступна.\n\n'
              'Пожалуйста, откройте настройки и предоставьте разрешение на использование геолокации.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Просто закрыть
                child: const Text('Закрыть'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text('Открыть настройки'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationTrackerStateSubs.cancel();
    _locationTrackerWidgetController.dispose();
    _locationTrackerBloc.close();
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        _locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        _locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
        title: const Text("Location Tracker", style: TextStyle(color: Colors.white)),
        actions: [
          ListenableBuilder(
            listenable: _locationTrackerWidgetController,
            builder: (context, child) {
              if (_locationTrackerWidgetController.isStarting ||
                  _locationTrackerWidgetController.isPausing ||
                  _locationTrackerWidgetController.isFinishing) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<LocationTrackerBloc, LocationTrackerState>(
            bloc: _locationTrackerBloc,
            builder: (context, state) {
              switch (state) {
                case LocationTracker$InitialState():
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                case LocationTracker$InProgressState():
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case LocationTracker$ErrorState():
                  return const SliverFillRemaining(
                    child: Center(child: Text(LocationTrackerMessageConstants.somethingWentWrong)),
                  );
                case LocationTracker$CompletedState():
                  final currentStateModel = state.locationTrackerStateModel;
                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentStateModel.lastValidPosition == null
                              ? "No location yet"
                              : "Lat: ${currentStateModel.lastValidPosition!.latitude}, Lng: ${currentStateModel.lastValidPosition!.longitude}",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentStateModel.speed == null
                              ? "No speed yet"
                              : "Speed: ${currentStateModel.speed}",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Text("Mode: $_movementMode"),
                        const SizedBox(height: 20),
                        ListenableBuilder(
                          listenable: _locationTrackerWidgetController,
                          builder: (context, child) {
                            return Column(
                              children: [
                                if (_locationTrackerWidgetController.isTracking)
                                  ElevatedButton(
                                    onPressed: () {
                                      _locationTrackerBloc.add(
                                        LocationTrackerEvent.pause(
                                          onMessage: _showMessage,
                                          onPause: () {
                                            _locationTrackerWidgetController.changeIsTracking(
                                              false,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("Pause"),
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_locationTrackerWidgetController.isTracking) {
                                      _locationTrackerBloc.add(
                                        LocationTrackerEvent.finish(
                                          onMessage: _showMessage,
                                          onFinish: () {
                                            _locationTrackerWidgetController.changeIsTracking(
                                              false,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      startTracking();
                                    }
                                  },
                                  child: Text(
                                    _locationTrackerWidgetController.isTracking
                                        ? "Stop Tracking"
                                        : "Start Tracking",
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 300,
                          child: FlutterMap(
                            mapController: _mapController,
                            options: const MapOptions(
                              maxZoom: 22,
                              minZoom: 6,
                              initialCenter: locationOfNewYork,
                              initialZoom: 11,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: mapTileUrl,
                                userAgentPackageName: 'com.example.app',
                              ),
                              if (currentStateModel.validatedPositions.isNotEmpty)
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      strokeWidth: 8,
                                      points:
                                          currentStateModel.validatedPositions
                                              .map(
                                                (point) =>
                                                    LatLng(point.latitude!, point.longitude!),
                                              )
                                              .toList(),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              if (currentStateModel.validatedPositions.isNotEmpty &&
                                  currentStateModel.validatedPositions.length >= 2)
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        currentStateModel.validatedPositions.first.latitude!,
                                        currentStateModel.validatedPositions.first.longitude!,
                                      ),
                                      width: 80,
                                      height: 80,
                                      child: const Text(
                                        "Start position",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Marker(
                                      point: LatLng(
                                        currentStateModel.validatedPositions.last.latitude!,
                                        currentStateModel.validatedPositions.last.longitude!,
                                      ),
                                      width: 80,
                                      height: 80,
                                      child: const Text(
                                        "Last position",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
