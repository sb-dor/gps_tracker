import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gps_tracker/src/common/constants/location_tracker_message_constants.dart';
import 'package:gps_tracker/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:gps_tracker/src/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'controllers/location_tracker_widget_controller.dart';

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
          11,
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
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                              initialCenter: LatLng(38.559772, 68.787038),
                              initialZoom: 11,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
