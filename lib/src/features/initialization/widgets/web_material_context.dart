import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gps_tracker/src/features/initialization/models/dependency_container.dart';
import 'package:gps_tracker/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:gps_tracker/src/features/location_tracker/widgets/location_tracker_widget.dart';

class WebMaterialContext extends StatefulWidget {
  const WebMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<WebMaterialContext> createState() => _WebMaterialContextState();
}

class _WebMaterialContextState extends State<WebMaterialContext> {
  @override
  Widget build(BuildContext context) {
     final mediaQueryData = MediaQuery.of(context);
    return DependenciesScope(
      dependencies: widget.dependencyContainer,
      child: MaterialApp(
        builder:
            (context, child) => MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.linear(mediaQueryData.textScaler.scale(1).clamp(0.5, 2)),
              ),
              child: child!,
            ),
        debugShowCheckedModeBanner: !kReleaseMode,
        home: LocationTrackerWidget(),
      ),
    );
  }
}
