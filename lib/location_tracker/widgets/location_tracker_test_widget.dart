import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gps_tracker/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:gps_tracker/location_tracker/constants/location_tracker_message_constants.dart';
import 'package:latlong2/latlong.dart';
import 'controllers/location_tracker_widget_controller.dart';
import 'location_tracker_widget.dart';

class LocationTrackerTestWidget extends StatefulWidget {
  const LocationTrackerTestWidget({super.key});

  @override
  State<LocationTrackerTestWidget> createState() => _LocationTrackerTestWidgetState();
}

class _LocationTrackerTestWidgetState extends State<LocationTrackerTestWidget> {
  final MapController _mapController = MapController();

  late final LocationTrackerBloc _locationTrackerBloc;
  late final LocationTrackerWidgetController _locationTrackerWidgetController;
  late final LocationTrackerWidgetState _locationTrackerWidgetState;

  @override
  void initState() {
    super.initState();
    _locationTrackerWidgetState = LocationTrackerInhWidget.of(context);
    _locationTrackerWidgetController = _locationTrackerWidgetState.locationTrackerWidgetController;
    _locationTrackerBloc = _locationTrackerWidgetState.locationTrackerBloc;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerState>(
      bloc: _locationTrackerBloc,
      builder: (context, state) {
        switch (state) {
          case LocationTracker$InitialState():
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          case LocationTracker$InProgressState():
            return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
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
                                      _locationTrackerWidgetController.changeIsTracking(false);
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
                                      _locationTrackerWidgetController.changeIsTracking(false);
                                    },
                                  ),
                                );
                              } else {
                                _locationTrackerWidgetState.startTracking();
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
                                        .map((point) => LatLng(point.latitude!, point.longitude!))
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
    );
  }
}
