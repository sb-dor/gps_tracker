import 'package:gps_tracker/src/features/location_tracker/models/location_tracker_data_model.dart';
import 'package:gps_tracker/src/features/location_tracker/models/shift_model.dart';

abstract interface class ILocationTrackerSendLocationDatasource {
  Future<bool> sendLocation({
    required final LocationTrackerDataModel locationTrackerDataModel,
    required final void Function(String message) onMessage,
  });

  Future<bool> sendListOfLocation({
    required final List<LocationTrackerDataModel> locations,
    required final void Function(String message) onMessage,
  });

  Future<ShiftModel?> currentShift({String? currentDateTime});
}

final class LocationTrackerSendLocationFakeDatasource
    implements ILocationTrackerSendLocationDatasource {
  @override
  Future<bool> sendLocation({
    required LocationTrackerDataModel? locationTrackerDataModel,
    required final void Function(String message) onMessage,
  }) => Future.value(true);

  @override
  Future<bool> sendListOfLocation({
    required List<LocationTrackerDataModel> locations,
    required final void Function(String message) onMessage,
  }) => Future.value(true);

  @override
  Future<ShiftModel?> currentShift({String? currentDateTime}) =>
      Future.value(null);
}
