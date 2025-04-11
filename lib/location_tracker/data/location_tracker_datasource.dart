import 'package:gps_tracker/location_tracker/models/location_tracker_data_model.dart';
import 'package:gps_tracker/location_tracker/models/shift_model.dart';

abstract interface class ILocationTrackerDatasource {
  Future<ShiftModel?> startShift({
    required final LocationTrackerDataModel? locationTrackerDataModel,
    required final void Function(String message) onMessage,
  });

  Future<bool> pause({required final void Function(String message) onMessage});

  Future<bool> finishShift({required final void Function(String message) onMessage});
}

final class LocationTrackerDatasourceFakeImpl implements ILocationTrackerDatasource {
  @override
  Future<bool> finishShift({required void Function(String message) onMessage}) =>
      Future.value(true);

  @override
  Future<ShiftModel?> startShift({
    required LocationTrackerDataModel? locationTrackerDataModel,
    required void Function(String message) onMessage,
  }) => Future.value(null);

  @override
  Future<bool> pause({required void Function(String message) onMessage}) => Future.value(true);
}
