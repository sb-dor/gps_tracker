import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_tracker/src/common/utils/bloc_observer/bloc_observer_manager.dart';
import 'package:gps_tracker/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:gps_tracker/src/features/initialization/widgets/io_material_context.dart';
import 'package:gps_tracker/src/features/initialization/widgets/web_material_context.dart';
import 'package:logger/logger.dart';

import 'factories/app_logger_factory.dart';

final class AppRunner {
  //
  Future<void> initialize() async {
    final logger =
        AppLoggerFactory(logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter()).create();
    //
    await runZonedGuarded(
      () async {
        final binding = WidgetsFlutterBinding.ensureInitialized();

        binding.deferFirstFrame();

        FlutterError.onError = (errorDetails) {
          logger.log(Level.error, errorDetails);
          // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          logger.log(Level.error, "error $error | stacktrace: $stack");
          // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };

        try {
          Bloc.transformer = sequential();
          Bloc.observer = BlocObserverManager(logger: logger);

          final dependencyContainer = DependencyComposition(logger: logger).create();

          late final Widget materialContext;

          if (kIsWeb || kIsWasm) {
            materialContext = WebMaterialContext(dependencyContainer: dependencyContainer);
          } else {
            materialContext = IoMaterialContext(dependencyContainer: dependencyContainer);
          }

          runApp(materialContext);
        } catch (error) {
          rethrow;
        } finally {
          binding.allowFirstFrame();
        }
      },
      (error, stackTrace) {
        logger.log(Level.debug, "Error: $error | stacktrace: $stackTrace");
      },
    );
  }
}
