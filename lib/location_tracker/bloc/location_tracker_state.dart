part of 'location_tracker_bloc.dart';

@immutable
sealed class LocationTrackerState {
  const LocationTrackerState(this.locationTrackerStateModel);

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

  final LocationTrackerStateModel locationTrackerStateModel;
}

final class LocationTracker$InitialState extends LocationTrackerState {
  const LocationTracker$InitialState(super.locationTrackerStateModel);
}

final class LocationTracker$InProgressState extends LocationTrackerState {
  const LocationTracker$InProgressState(super.locationTrackerStateModel);
}

final class LocationTracker$ErrorState extends LocationTrackerState {
  const LocationTracker$ErrorState(super.locationTrackerStateModel);
}

final class LocationTracker$CompletedState extends LocationTrackerState {
  const LocationTracker$CompletedState(super.locationTrackerStateModel);
}
