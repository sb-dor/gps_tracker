import 'package:flutter/foundation.dart';
import 'package:gps_tracker/src/features/location_tracker/models/shift_model.dart';
import 'package:location/location.dart';

import 'location_tracker_data_model.dart';

@immutable
class LocationTrackerStateModel {
  const LocationTrackerStateModel({
    this.shift,
    this.lastValidPosition,
    this.locationTrackerDataModel,
    this.validatedPositions = const <LocationData>[],
    this.speed,
  });

  final ShiftModel? shift;
  final LocationData? lastValidPosition;
  final LocationTrackerDataModel?
  locationTrackerDataModel; // for sending to the server
  final List<LocationData>
  validatedPositions; // just for test, will be removed in the future
  final double? speed; // just for test, will be removed in the future

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationTrackerStateModel &&
          runtimeType == other.runtimeType &&
          shift == other.shift &&
          lastValidPosition == other.lastValidPosition &&
          locationTrackerDataModel == other.locationTrackerDataModel &&
          validatedPositions == other.validatedPositions &&
          speed == other.speed);

  @override
  int get hashCode =>
      lastValidPosition.hashCode ^
      validatedPositions.hashCode ^
      locationTrackerDataModel.hashCode ^
      shift.hashCode ^
      speed.hashCode;

  @override
  String toString() {
    return 'LocationTrackerStateModel{'
        ' lastValidPosition: $lastValidPosition,'
        ' validatedPositions: $validatedPositions,'
        ' locationTrackerDataModel: $locationTrackerDataModel'
        ' shift: $shift'
        ' speed: $speed'
        '}';
  }

  LocationTrackerStateModel copyWith({
    ShiftModel? shift,
    LocationData? lastValidPosition,
    List<LocationData>? validatedPositions,
    LocationTrackerDataModel? locationTrackerDataModel,
    double? speed,
    //
    bool setLastValidPositionOnNull = false,
    bool setLocationTrackerDataModelOnNull = false,
    bool setShiftOnNull = false,
    bool setSpeedOnNull = false,
  }) {
    return LocationTrackerStateModel(
      shift: setShiftOnNull ? shift : shift ?? this.shift,
      lastValidPosition:
          setLastValidPositionOnNull
              ? lastValidPosition
              : lastValidPosition ?? this.lastValidPosition,
      locationTrackerDataModel:
          setLocationTrackerDataModelOnNull
              ? locationTrackerDataModel
              : locationTrackerDataModel ?? this.locationTrackerDataModel,
      validatedPositions: validatedPositions ?? this.validatedPositions,
      speed: setSpeedOnNull ? speed : speed ?? this.speed,
    );
  }
}
