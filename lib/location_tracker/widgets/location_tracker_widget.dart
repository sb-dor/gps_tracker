import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_store/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:my_store/features/location_tracker/widgets/location_tracker_test_widget.dart';
import 'package:my_store/utils/colors.dart';
import 'controllers/location_tracker_widget_controller.dart';
import 'location_tracker_actual_widget.dart';

class LocationTrackerInhWidget extends InheritedWidget {
  const LocationTrackerInhWidget({
    super.key,
    required super.child,
    required this.locationTrackerWidgetState,
  });

  static LocationTrackerWidgetState of(BuildContext context, {bool listen = false}) =>
      listen
          ? context
              .dependOnInheritedWidgetOfExactType<LocationTrackerInhWidget>()!
              .locationTrackerWidgetState
          : context
              .getInheritedWidgetOfExactType<LocationTrackerInhWidget>()!
              .locationTrackerWidgetState;

  final LocationTrackerWidgetState locationTrackerWidgetState;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

// THE MAIN LOGIC USAGE
class LocationTrackerWidget extends StatefulWidget {
  const LocationTrackerWidget({super.key, required this.locationTrackerBloc});

  final LocationTrackerBloc locationTrackerBloc;

  @override
  State<LocationTrackerWidget> createState() => LocationTrackerWidgetState();
}

class LocationTrackerWidgetState extends State<LocationTrackerWidget> with WidgetsBindingObserver {
  late final LocationTrackerWidgetController locationTrackerWidgetController;
  late final LocationTrackerBloc locationTrackerBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locationTrackerWidgetController = LocationTrackerWidgetController();
    locationTrackerBloc = widget.locationTrackerBloc;
    locationTrackerBloc.add(
      LocationTrackerEvent.initial(
        locationWidgetController: locationTrackerWidgetController,
        startTracking: startTracking,
      ),
    );
  }

  void startTracking({bool checkIsStarting = true}) {
    if (locationTrackerWidgetController.isStarting && checkIsStarting) {
      EasyLoading.showInfo("Пожалуйста подождите");
      return;
    }
    locationTrackerWidgetController.changeIsStarting(true);
    locationTrackerBloc.add(
      LocationTrackerEvent.start(
        onMessage: (String message) {
          EasyLoading.showInfo(message);
        },
        onStart: () {
          locationTrackerWidgetController.changeIsTracking(true);
        },
        onFinish: () {
          locationTrackerWidgetController.changeIsStarting(false);
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    locationTrackerWidgetController.dispose();
    locationTrackerBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        locationTrackerWidgetController.saveLastInActiveDateTime();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return LocationTrackerInhWidget(
      locationTrackerWidgetState: this,
      child: const LocationTrackerWidgetDelegate(),
    );
  }
}

class LocationTrackerWidgetDelegate extends StatefulWidget {
  const LocationTrackerWidgetDelegate({super.key});

  @override
  State<LocationTrackerWidgetDelegate> createState() => _LocationTrackerWidgetDelegateState();
}

class _LocationTrackerWidgetDelegateState extends State<LocationTrackerWidgetDelegate> {
  late final LocationTrackerWidgetController _locationTrackerWidgetController;

  @override
  void initState() {
    super.initState();
    _locationTrackerWidgetController =
        LocationTrackerInhWidget.of(context).locationTrackerWidgetController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainAppColor,
        elevation: 0.0,
        title: const Text("Location Tracker"),
        actions: [
          ListenableBuilder(
            listenable: _locationTrackerWidgetController,
            builder: (context, child) {
              if (_locationTrackerWidgetController.isStarting ||
                  _locationTrackerWidgetController.isPausing ||
                  _locationTrackerWidgetController.isFinishing) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: const CustomScrollView(slivers: [LocationTrackerActualWidget()]),
    );
  }
}
