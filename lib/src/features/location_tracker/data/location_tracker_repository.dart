import 'package:gps_tracker/src/features/location_tracker/models/location_tracker_data_model.dart';
import 'package:gps_tracker/src/features/location_tracker/models/shift_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'location_tracker_datasource.dart';
import 'location_tracker_send_location_datasource.dart';

abstract interface class ILocationTrackerRepository {
  Future<ShiftModel?> startShift({
    required final LocationTrackerDataModel? locationTrackerDataModel,
    required final void Function(String message) onMessage,
  });

  Future<bool> pause({required final void Function(String message) onMessage});

  Future<bool> finishShift({required final void Function(String message) onMessage});

  Future<ShiftModel?> currentShift();

  Future<bool> sendLocation({
    required final LocationTrackerDataModel locationTrackerDataModel,
    required final void Function(String message) onMessage,
  });

  Future<bool> sendListOfLocations({
    required final List<LocationTrackerDataModel> locations,
    required final void Function(String message) onMessage,
  });
}

final class LocationTrackerRepositoryImpl implements ILocationTrackerRepository {
  LocationTrackerRepositoryImpl({
    required final ILocationTrackerDatasource iLocationTrackerDatasource,
    required final ILocationTrackerSendLocationDatasource
    iLocationTrackerSendLocationRemoteDatasource,
    required final ILocationTrackerSendLocationDatasource
    iLocationTrackerSendLocationLocalDatasource,
  }) : _iLocationTrackerDatasource = iLocationTrackerDatasource,
       _iLocationTrackerSendLocationRemoteDatasource = iLocationTrackerSendLocationRemoteDatasource,
       _iLocationTrackerSendLocationLocalDatasource = iLocationTrackerSendLocationLocalDatasource;

  final ILocationTrackerDatasource _iLocationTrackerDatasource;
  final ILocationTrackerSendLocationDatasource _iLocationTrackerSendLocationRemoteDatasource;
  final ILocationTrackerSendLocationDatasource _iLocationTrackerSendLocationLocalDatasource;

  @override
  Future<ShiftModel?> startShift({
    required final LocationTrackerDataModel? locationTrackerDataModel,
    required final void Function(String message) onMessage,
  }) => _iLocationTrackerDatasource.startShift(
    onMessage: onMessage,
    locationTrackerDataModel: locationTrackerDataModel,
  );

  @override
  Future<bool> finishShift({required void Function(String message) onMessage}) =>
      _iLocationTrackerDatasource.finishShift(onMessage: onMessage);

  @override
  Future<bool> pause({required void Function(String message) onMessage}) =>
      _iLocationTrackerDatasource.pause(onMessage: onMessage);

  @override
  Future<ShiftModel?> currentShift() async {
    final internetConnection = await InternetConnectionChecker.instance.hasConnection;

    if (internetConnection) {
      final lastInactiveDateTime = DateTime.now().toString();
      return _iLocationTrackerSendLocationRemoteDatasource.currentShift(
        currentDateTime: lastInactiveDateTime,
      );
    } else {
      return _iLocationTrackerSendLocationLocalDatasource.currentShift();
    }
  }

  // ------
  // 1. check the internet connection
  // - if there is a internet connection
  // 2. first check whether data exist in local database (for ex: internet connection dies for a second or 10, and records should be saved somewhere)
  // - if there are data inside local database, send them
  // 3. send current location
  // 4. if there is no internet connection, save that current location inside local database
  @override
  Future<bool> sendLocation({
    required LocationTrackerDataModel locationTrackerDataModel,
    required void Function(String message) onMessage,
  }) async {
    final internetConnection = await InternetConnectionChecker.instance.hasConnection;

    if (internetConnection) {
      final localSavedLocations = <LocationTrackerDataModel>[];

      if (localSavedLocations.isNotEmpty) {
        // if you had 5 locations which were saved in local database
        // and while you are sending them to the server, other data will be saved inside local database
        // but this logic gets only available locations and sends them to the server
        // not other data that came during send
        await sendListOfLocations(locations: localSavedLocations, onMessage: onMessage);
      }

      return _iLocationTrackerSendLocationRemoteDatasource.sendLocation(
        locationTrackerDataModel: locationTrackerDataModel,
        onMessage: onMessage,
      );
    } else {
      return _iLocationTrackerSendLocationLocalDatasource.sendLocation(
        locationTrackerDataModel: locationTrackerDataModel,
        onMessage: onMessage,
      );
    }
  }

  @override
  Future<bool> sendListOfLocations({
    required List<LocationTrackerDataModel> locations,
    required void Function(String message) onMessage,
  }) {
    return _iLocationTrackerSendLocationRemoteDatasource.sendListOfLocation(
      locations: locations,
      onMessage: onMessage,
    );
  }
}
