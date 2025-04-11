import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_tracker/location_tracker/data/location_tracker_repository.dart';
import 'package:gps_tracker/location_tracker/helpers/location_tracker_helper.dart';
import 'package:gps_tracker/location_tracker/models/location_tracker_data_model.dart';
import 'package:gps_tracker/location_tracker/models/location_tracker_state_model.dart';
import 'package:gps_tracker/location_tracker/models/shift_model.dart';
import 'package:location/location.dart';

part 'location_tracker_event.dart';

part 'location_tracker_state.dart';

class LocationTrackerBloc extends Bloc<LocationTrackerEvent, LocationTrackerState> {
  LocationTrackerBloc({
    required final ILocationTrackerRepository repository,
    required final LocationTrackerHelper locationTrackerHelper,
    required final Location location,
    required final Duration timerDuration,
    LocationTrackerState? initialState,
  }) : _iLocationTrackerRepository = repository,
       _locationTrackerHelper = locationTrackerHelper,
       _location = location,
       _timerDuration = timerDuration,

       super(initialState ?? LocationTrackerState.initialState) {
    //
    on<LocationTrackerEvent>(
      (event, emit) => switch (event) {
        final _LocationTracker$InitialEvent event => _locationTracker$InitialEvent(event, emit),
        final _LocationTracker$StartEvent event => _locationTracker$StartEvent(event, emit),
        final _LocationTracker$PauseEvent event => _locationTracker$PauseEvent(event, emit),
        final _LocationTracker$CurrentLocationEvent event => _getCurrentBestLocation(
          emit,
          event.onMessage,
        ),
        final _LocationTracker$FinishEvent event => _locationTracker$StopEvent(event, emit),
      },
    );
  }

  final ILocationTrackerRepository _iLocationTrackerRepository;
  final LocationTrackerHelper _locationTrackerHelper;
  final Location _location;
  final Duration _timerDuration;
  Timer? _timerForGettingCurrentPosition;

  void _locationTracker$InitialEvent(
    _LocationTracker$InitialEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    if (event.locationWidgetController.isTracking) return;

    emit(LocationTrackerState.inProgress(state.locationTrackerStateModel));

    final checkPermission = await _locationTrackerHelper.checkPermission();

    if (!checkPermission) {
      emit(LocationTrackerState.completed(state.locationTrackerStateModel));
      return;
    }

    _prepareData(emit);

    // from widgetController that handles the logic of the ui
    event.locationWidgetController.changeIsStarting(true);

    // sends last inactive datetime (take a look inside repository)
    final currentShift = await _iLocationTrackerRepository.currentShift();

    final currentStateModel = state.locationTrackerStateModel.copyWith(
      shift: currentShift,
      setShiftOnNull: true,
    );

    emit(LocationTrackerState.completed(currentStateModel));

    if (currentShift != null) {
      event.startTracking(checkIsStarting: false);
    }

    await _sendLocalLocations(currentShift);
  }

  void _locationTracker$StartEvent(
    _LocationTracker$StartEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    final checkPermission = await _locationTrackerHelper.checkPermission();

    if (!checkPermission) {
      event.onFinish();
      return;
    }

    _prepareData(emit, isTracking: true);

    await _getCurrentBestLocation(emit, event.onMessage, checkValidPosition: false);

    event.onStart();

    // start or even continue shift, because if suddenly user's phone dies
    // make request just once again and
    final shift = await _iLocationTrackerRepository.startShift(
      onMessage: event.onMessage,
      locationTrackerDataModel: state.locationTrackerStateModel.locationTrackerDataModel,
    );

    if (shift != null) {
      final currentStateModel = state.locationTrackerStateModel.copyWith(
        shift: shift,
        setShiftOnNull: true,
      );
      _emitter(emit, stateModel: currentStateModel);
    }

    event.onFinish();

    _timerForGettingCurrentPosition = Timer.periodic((_timerDuration), (_) async {
      add(LocationTrackerEvent.currentLocation(onMessage: event.onMessage));
    });
  }

  void _locationTracker$PauseEvent(
    _LocationTracker$PauseEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    final pauseShift = await _iLocationTrackerRepository.pause(onMessage: event.onMessage);

    if (!pauseShift) return;

    event.onPause();

    _timerForGettingCurrentPosition?.cancel();
    _timerForGettingCurrentPosition = null;
    _emitter(emit);
  }

  void _locationTracker$StopEvent(
    _LocationTracker$FinishEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    await _sendLocalLocations(state.locationTrackerStateModel.shift);

    final finishShift = await _iLocationTrackerRepository.finishShift(onMessage: event.onMessage);

    if (!finishShift) return;

    event.onFinish();

    final currentStateModel = state.locationTrackerStateModel.copyWith(
      lastValidPosition: null,
      shift: null,
      setLastValidPositionOnNull: true,
      setShiftOnNull: true,
    );
    _timerForGettingCurrentPosition?.cancel();
    _timerForGettingCurrentPosition = null;
    _emitter(emit, stateModel: currentStateModel);
  }

  void _prepareData(Emitter<LocationTrackerState> emit, {bool isTracking = false}) async {
    final currentStateModel = state.locationTrackerStateModel.copyWith(
      // validatedPositions: <LocationData>[],
      lastValidPosition: null,
      locationTrackerDataModel: null,
      setLastValidPositionOnNull: true,
      setLocationTrackerDataModelOnNull: true,
    );
    _timerForGettingCurrentPosition?.cancel();
    _timerForGettingCurrentPosition = null;
    _emitter(emit, stateModel: currentStateModel);
  }

  Future<void> _getCurrentBestLocation(
    Emitter<LocationTrackerState> emit,
    void Function(String message) onMessage, {
    bool checkValidPosition = true,
  }) async {
    final getHighAccuracyLocation = await _location.getLocation();

    DateTime? positionDateTime;
    double? positionDistance;

    if (checkValidPosition) {
      final isValidPosition = _locationTrackerHelper.isValidPosition(
        getHighAccuracyLocation,
        state.locationTrackerStateModel.lastValidPosition,
      );

      if (!isValidPosition.isValid) return;

      positionDateTime = isValidPosition.positionDateTime;
      positionDistance = isValidPosition.distance;
    } else {
      positionDateTime = _locationTrackerHelper.parsedDateTimeFromSinceEpoch(
        (getHighAccuracyLocation.time ?? 0.0).toInt(),
      );
    }

    final LocationTrackerDataModel locationTrackerDataModel = LocationTrackerDataModel(
      parsedDateTime: positionDateTime,
      locationData: getHighAccuracyLocation,
      distance: positionDistance,
    );

    final validatedPositions = List.of(state.locationTrackerStateModel.validatedPositions);

    validatedPositions.add(getHighAccuracyLocation);

    final currentStateModel = state.locationTrackerStateModel.copyWith(
      lastValidPosition: getHighAccuracyLocation,
      validatedPositions: validatedPositions,
      locationTrackerDataModel: locationTrackerDataModel,
      setLocationTrackerDataModelOnNull: true,
    );

    // print("validated positions length is: ${validatedPositions.length}");
    _emitter(emit, stateModel: currentStateModel);

    if (checkValidPosition) {
      await _iLocationTrackerRepository.sendLocation(
        locationTrackerDataModel: locationTrackerDataModel,
        onMessage: onMessage,
      );
    }
  }

  Future<void> _sendLocalLocations(ShiftModel? currentShift) async {
    final unsentLocations = <LocationTrackerDataModel>[];

    if (unsentLocations.isNotEmpty && currentShift != null) {
      await _iLocationTrackerRepository.sendListOfLocations(
        locations: unsentLocations,
        onMessage: (String message) {},
      );
    }
  }

  void _emitter(Emitter<LocationTrackerState> emit, {LocationTrackerStateModel? stateModel}) {
    switch (state) {
      case LocationTracker$InitialState():
        emit(LocationTrackerState.initial(stateModel ?? state.locationTrackerStateModel));
        break;
      case LocationTracker$InProgressState():
        emit(LocationTrackerState.inProgress(stateModel ?? state.locationTrackerStateModel));
        break;
      case LocationTracker$ErrorState():
        emit(LocationTrackerState.error(stateModel ?? state.locationTrackerStateModel));
        break;
      case LocationTracker$CompletedState():
        emit(LocationTrackerState.completed(stateModel ?? state.locationTrackerStateModel));
        break;
    }
  }

  @override
  Future<void> close() {
    _timerForGettingCurrentPosition?.cancel();
    _timerForGettingCurrentPosition = null;
    return super.close();
  }
}
