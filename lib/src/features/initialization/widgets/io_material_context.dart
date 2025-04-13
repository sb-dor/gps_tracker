import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracker/runner_io.dart';
import 'package:gps_tracker/src/features/initialization/logic/app_runner.dart';
import 'package:gps_tracker/src/features/initialization/logic/desktop_initializer.dart';
import 'package:gps_tracker/src/features/initialization/models/dependency_container.dart';
import 'package:gps_tracker/src/features/location_tracker/widgets/location_tracker_widget.dart';
import 'package:window_manager/window_manager.dart';

import 'dependencies_scope.dart';

class IoMaterialContext extends StatefulWidget {
  const IoMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<IoMaterialContext> createState() => _IoMaterialContextState();
}

class _IoMaterialContextState extends State<IoMaterialContext> with WindowListener {
  final fadeTransitionPlatforms = {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
  };

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final getSize = await windowManager.getSize();
    final minSize = desktopMinSize;
    if (getSize.width < minSize.width || getSize.height < minSize.height) {
      windowManager.setMinimumSize(desktopMinSize);
    }
    super.onWindowResize();
  }

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: widget.dependencyContainer,
      child: MaterialApp(
        home: LocationTrackerWidget(),
        debugShowCheckedModeBanner: !kReleaseMode,
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: fadeTransitionPlatforms),
        ),
      ),
    );
  }
}
