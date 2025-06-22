import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_tracker/src/common/constants/location_tracker_message_constants.dart';
import 'package:gps_tracker/src/features/location_tracker/data/location_tracker_repository.dart';
import 'package:gps_tracker/src/features/location_tracker/helpers/location_tracker_helper.dart';
import 'package:gps_tracker/src/features/location_tracker/models/location_tracker_data_model.dart';
import 'package:gps_tracker/src/features/location_tracker/models/location_tracker_state_model.dart';
import 'package:gps_tracker/src/features/location_tracker/models/shift_model.dart';
import 'package:gps_tracker/src/features/location_tracker/widgets/controllers/location_tracker_widget_controller.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

part 'location_tracker_bloc.freezed.dart';

typedef FutureVoidCallback = Future<void> Function();

@immutable
@freezed
sealed class LocationTrackerEvent with _$LocationTrackerEvent {
  const LocationTrackerEvent._();

  const factory LocationTrackerEvent.initial({
    required final LocationTrackerWidgetController locationWidgetController,
    required final Function({bool checkIsStarting}) startTracking,
    required final FutureVoidCallback locationNotificationDialog,
    required final Function(String message) onMessage,
  }) = _LocationTracker$InitialEvent;

  const factory LocationTrackerEvent.start({
    required final void Function(String message) onMessage,
    required final void Function() onStart,
    required final void Function() onFinish,
    required final FutureVoidCallback locationNotificationDialog,
  }) = _LocationTracker$StartEvent;

  const factory LocationTrackerEvent.pause({
    required final void Function(String message) onMessage,
    required final void Function() onPause,
  }) = _LocationTracker$PauseEvent;

  const factory LocationTrackerEvent.currentLocation({
    required final void Function(String message) onMessage,
    required final List<LocationData> locations,
  }) = _LocationTracker$CurrentLocationEvent;

  const factory LocationTrackerEvent.finish({
    required final void Function(String message) onMessage,
    required final void Function() onFinish,
  }) = _LocationTracker$FinishEvent;
}

@immutable
@freezed
sealed class LocationTrackerState with _$LocationTrackerState {
  const LocationTrackerState._();

  const factory LocationTrackerState.initial(
    final LocationTrackerStateModel locationTrackerStateModel,
  ) = LocationTracker$InitialState;

  const factory LocationTrackerState.inProgress(
    final LocationTrackerStateModel locationTrackerStateModel,
  ) = LocationTracker$InProgressState;

  const factory LocationTrackerState.error(
    final LocationTrackerStateModel locationTrackerStateModel,
  ) = LocationTracker$ErrorState;

  const factory LocationTrackerState.completed(
    final LocationTrackerStateModel locationTrackerStateModel,
  ) = LocationTracker$CompletedState;

  static LocationTrackerState get initialState =>
      const LocationTrackerState.initial(LocationTrackerStateModel());
}

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
          event.locations,
        ),
        final _LocationTracker$FinishEvent event => _locationTracker$StopEvent(event, emit),
      },
    );
  }

  final ILocationTrackerRepository _iLocationTrackerRepository;
  final LocationTrackerHelper _locationTrackerHelper;
  final Location _location;
  final Duration _timerDuration;
  StreamSubscription<List<LocationData>>? _onLocationChanged;

  void _locationTracker$InitialEvent(
    _LocationTracker$InitialEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    try {
      if (event.locationWidgetController.isTracking) return;

      emit(LocationTrackerState.inProgress(state.locationTrackerStateModel));

      final checkPermission = await _locationTrackerHelper.checkPermission(
        onErrorMessage: event.onMessage,
        locationNotificationDialog: event.locationNotificationDialog,
      );

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
      } else {
        event.locationWidgetController.changeIsStarting(false);
      }

      await _sendLocalLocations(currentShift);
    } on PlatformException catch (error, stackTrace) {
      if ((error.code.contains(LocationTrackerMessageConstants.permissionDenied))) {
        final message = "${LocationTrackerMessageConstants.permissionDenied} ${error.message}";
        event.onMessage(message);
      } else {
        final message =
            "${LocationTrackerMessageConstants.platformExceptionError} ${error.message}";
        event.onMessage(message);
      }
      emit(LocationTrackerState.completed(state.locationTrackerStateModel));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _locationTracker$StartEvent(
    _LocationTracker$StartEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    try {
      final checkPermission = await _locationTrackerHelper.checkPermission(
        onErrorMessage: event.onMessage,
        locationNotificationDialog: event.locationNotificationDialog,
      );

      if (!checkPermission) {
        event.onFinish();
        return;
      }

      _prepareData(emit, isTracking: true);

      final location = await _location.getLocation();

      await _getCurrentBestLocation(emit, event.onMessage, [location], checkValidPosition: false);

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

      _onLocationChanged = _location.onLocationChanged.bufferTime(_timerDuration).listen((data) {
        add(LocationTrackerEvent.currentLocation(onMessage: event.onMessage, locations: data));
      });
    } on PlatformException catch (error, stackTrace) {
      if ((error.code.contains(LocationTrackerMessageConstants.permissionDenied))) {
        final message = "${LocationTrackerMessageConstants.permissionDenied} ${error.message}";
        event.onMessage(message);
      } else {
        final message =
            "${LocationTrackerMessageConstants.platformExceptionError} ${error.message}";
        event.onMessage(message);
      }
      event.onFinish();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _locationTracker$PauseEvent(
    _LocationTracker$PauseEvent event,
    Emitter<LocationTrackerState> emit,
  ) async {
    final pauseShift = await _iLocationTrackerRepository.pause(onMessage: event.onMessage);

    if (!pauseShift) return;

    event.onPause();

    _onLocationChanged?.cancel();
    _onLocationChanged = null;
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
      speed: null,
      setLastValidPositionOnNull: true,
      setShiftOnNull: true,
      setSpeedOnNull: true,
    );
    _onLocationChanged?.cancel();
    _onLocationChanged = null;
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
    _onLocationChanged?.cancel();
    _onLocationChanged = null;
    _emitter(emit, stateModel: currentStateModel);
  }

  Future<void> _getCurrentBestLocation(
    Emitter<LocationTrackerState> emit,
    void Function(String message) onMessage,
    List<LocationData> locations, {
    bool checkValidPosition = true,
  }) async {
    for (final location in locations.reversed) {
      DateTime? positionDateTime;
      double? positionDistance;
      double? speed;

      if (checkValidPosition) {
        final isValidPosition = _locationTrackerHelper.isValidPosition(
          location,
          state.locationTrackerStateModel.lastValidPosition,
        );

        if (!isValidPosition.isValid) continue;

        positionDateTime = isValidPosition.positionDateTime;
        positionDistance = isValidPosition.distance;
        speed = isValidPosition.speed;
      } else {
        positionDateTime = _locationTrackerHelper.parsedDateTimeFromSinceEpoch(
          (location.time ?? 0.0).toInt(),
        );
      }

      final LocationTrackerDataModel locationTrackerDataModel = LocationTrackerDataModel(
        locationData: location,
        parsedDateTime: positionDateTime,
        distance: positionDistance,
      );

      final validatedPositions = List.of(state.locationTrackerStateModel.validatedPositions);

      validatedPositions.add(location);

      final currentStateModel = state.locationTrackerStateModel.copyWith(
        lastValidPosition: location,
        validatedPositions: validatedPositions,
        locationTrackerDataModel: locationTrackerDataModel,
        setLocationTrackerDataModelOnNull: true,
        speed: speed,
      );

      // print("validated positions length is: ${validatedPositions.length}");
      _emitter(emit, stateModel: currentStateModel);

      if (checkValidPosition) {
        await _iLocationTrackerRepository.sendLocation(
          locationTrackerDataModel: locationTrackerDataModel,
          onMessage: onMessage,
        );
      }

      // at least one coordinate should be good
      break;
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
    _onLocationChanged?.cancel();
    _onLocationChanged = null;
    return super.close();
  }
}
