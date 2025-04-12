import 'package:device_info_plus/device_info_plus.dart';
import 'package:gps_tracker/src/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:gps_tracker/src/features/location_tracker/data/location_tracker_datasource.dart';
import 'package:gps_tracker/src/features/location_tracker/data/location_tracker_repository.dart';
import 'package:gps_tracker/src/features/location_tracker/data/location_tracker_send_location_datasource.dart';
import 'package:gps_tracker/src/features/location_tracker/helpers/location_tracker_helper.dart';
import 'package:location/location.dart';

class LocationTrackerBlocFactory {
  LocationTrackerBlocFactory({
    required final Location location,
    required final DeviceInfoPlugin deviceInfoPlugin,
  }) : _location = location,
       _deviceInfoPlugin = deviceInfoPlugin;

  final Location _location;
  final DeviceInfoPlugin _deviceInfoPlugin;

  LocationTrackerBloc create() {
    // ---------- Fake implementations
    final ILocationTrackerDatasource datasource = LocationTrackerDatasourceFakeImpl();

    final locationSendLocal = LocationTrackerSendLocationFakeDatasource();

    final locationSendRemote = LocationTrackerSendLocationFakeDatasource();
    // ------------

    final ILocationTrackerRepository repository = LocationTrackerRepositoryImpl(
      iLocationTrackerDatasource: datasource,
      iLocationTrackerSendLocationRemoteDatasource: locationSendRemote,
      iLocationTrackerSendLocationLocalDatasource: locationSendLocal,
    );

    final locationTrackerHelper = LocationTrackerHelper(_location);

    return LocationTrackerBloc(
      repository: repository,
      locationTrackerHelper: locationTrackerHelper,
      location: _location,
      timerDuration: const Duration(seconds: 10),
    );
  }
}
