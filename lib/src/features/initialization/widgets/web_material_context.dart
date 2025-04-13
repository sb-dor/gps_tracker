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
    return DependenciesScope(
      dependencies: widget.dependencyContainer,
      child: MaterialApp(
        debugShowCheckedModeBanner: !kReleaseMode,
        home: LocationTrackerWidget(),
      ),
    );
  }
}
