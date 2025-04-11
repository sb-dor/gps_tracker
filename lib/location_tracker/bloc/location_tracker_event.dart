part of 'location_tracker_bloc.dart';

@immutable
sealed class LocationTrackerEvent {
  const LocationTrackerEvent();

  const factory LocationTrackerEvent.initial({
    required final LocationTrackerWidgetController locationWidgetController,
    required final Function({bool checkIsStarting}) startTracking,
  }) = _LocationTracker$InitialEvent;

  const factory LocationTrackerEvent.start({
    required final void Function(String message) onMessage,
    required final void Function() onStart,
    required final void Function() onFinish,
  }) = _LocationTracker$StartEvent;

  const factory LocationTrackerEvent.pause({
    required final void Function(String message) onMessage,
    required final void Function() onPause,
  }) = _LocationTracker$PauseEvent;

  const factory LocationTrackerEvent.currentLocation({
    required final void Function(String message) onMessage,
  }) = _LocationTracker$CurrentLocationEvent;

  const factory LocationTrackerEvent.finish({
    required final void Function(String message) onMessage,
    required final void Function() onFinish,
  }) = _LocationTracker$FinishEvent;
}

final class _LocationTracker$InitialEvent extends LocationTrackerEvent {
  const _LocationTracker$InitialEvent({
    required this.locationWidgetController,
    required this.startTracking,
  });

  final LocationTrackerWidgetController locationWidgetController;
  final void Function({bool checkIsStarting}) startTracking;
}

final class _LocationTracker$StartEvent extends LocationTrackerEvent {
  const _LocationTracker$StartEvent({
    required this.onMessage,
    required this.onStart,
    required this.onFinish,
  });

  final void Function(String message) onMessage;
  final void Function() onStart;
  final void Function() onFinish;
}

final class _LocationTracker$PauseEvent extends LocationTrackerEvent {
  const _LocationTracker$PauseEvent({
    required this.onMessage,
    required this.onPause,
  });

  final void Function(String message) onMessage;
  final void Function() onPause;
}

final class _LocationTracker$CurrentLocationEvent extends LocationTrackerEvent {
  const _LocationTracker$CurrentLocationEvent({required this.onMessage});

  final void Function(String message) onMessage;
}

final class _LocationTracker$FinishEvent extends LocationTrackerEvent {
  const _LocationTracker$FinishEvent({required this.onMessage, required this.onFinish});

  final void Function(String message) onMessage;
  final void Function() onFinish;
}
