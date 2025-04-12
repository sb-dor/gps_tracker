import 'package:device_info_plus/device_info_plus.dart';
import 'package:gps_tracker/src/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class DependencyContainer {
  DependencyContainer({
    required this.location,
    required this.locationTrackerBloc,
    required this.deviceInfoPlugin,
    required this.logger,
  });

  final Location location;
  final LocationTrackerBloc locationTrackerBloc;
  final DeviceInfoPlugin deviceInfoPlugin;
  final Logger logger;
}
