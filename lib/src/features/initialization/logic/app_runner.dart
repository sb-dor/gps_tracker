import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_tracker/runner_io.dart';
import 'package:gps_tracker/src/common/utils/bloc_observer/bloc_observer_manager.dart';
import 'package:gps_tracker/src/common/utils/reusable_global_functions.dart';
import 'package:gps_tracker/src/features/initialization/logic/dependency_composition/dependency_composition.dart';
import 'package:gps_tracker/src/features/initialization/widgets/io_material_context.dart';
import 'package:gps_tracker/src/features/initialization/widgets/web_material_context.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';

import 'factories/app_logger_factory.dart';

const desktopMinSize = Size(600, 600);

class AppRunner {
  //
  Future<void> initialize() async {
    final logger =
        AppLoggerFactory(logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter()).create();
    //
    await runZonedGuarded(
      () async {
        final binding = WidgetsFlutterBinding.ensureInitialized();

        binding.deferFirstFrame();

        await DesktopInitializer().run();

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

class DesktopInitializer {
  Future<void> run() async {
    if (ReusableGlobalFunctions.instance.isDesktop) {
      await windowManager.ensureInitialized();
      final WindowOptions windowOptions = WindowOptions(
        size: desktopMinSize,
        minimumSize: desktopMinSize,
        center: true,
        backgroundColor: Colors.transparent,
        // skipTaskbar: false,
        // titleBarStyle: TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}
