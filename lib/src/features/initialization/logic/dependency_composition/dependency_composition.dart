import 'package:device_info_plus/device_info_plus.dart';
import 'package:gps_tracker/src/features/initialization/logic/factories/factory.dart';
import 'package:gps_tracker/src/features/initialization/logic/factories/location_tracker_bloc_factory.dart';
import 'package:gps_tracker/src/features/initialization/models/dependency_container.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

final class DependencyComposition extends Factory<DependencyContainer> {
  DependencyComposition({required final Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  DependencyContainer create() {
    final location = Location();
    final deviceInfoPlugin = DeviceInfoPlugin();

    return DependencyContainer(
      location: location,
      locationTrackerBloc:
          LocationTrackerBlocFactory(
            location: location,
            deviceInfoPlugin: deviceInfoPlugin,
          ).create(),
      deviceInfoPlugin: deviceInfoPlugin,
      logger: _logger,
    );
  }
}
