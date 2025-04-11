import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gps_tracker/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:my_store/features/customer_address_creation/factory/customer_address_creation_factory.dart';
import 'package:my_store/features/customer_address_creation/widgets/customer_address_creation_config_widget.dart';
import 'package:my_store/features/customer_addresses/factory/customer_addresses_bloc_factory.dart';
import 'package:my_store/features/customer_addresses/widgets/customer_addresses_configuration_widget.dart';
import 'package:my_store/features/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:my_store/screens/customer_creator_screen.dart';
import 'package:my_store/screens/customer_screen.dart';
import 'package:my_store/utils/colors.dart';
import 'package:my_store/utils/constants.dart';
import 'package:my_store/widgets/text_widget.dart';

import 'controllers/location_tracker_widget_controller.dart';
import 'location_tracker_widget.dart';

class LocationTrackerActualWidget extends StatefulWidget {
  const LocationTrackerActualWidget({super.key});

  @override
  State<LocationTrackerActualWidget> createState() => _LocationTrackerActualWidgetState();
}

class _LocationTrackerActualWidgetState extends State<LocationTrackerActualWidget> {
  late final LocationTrackerBloc _locationTrackerBloc;
  late final LocationTrackerWidgetController _locationTrackerWidgetController;
  late final LocationTrackerWidgetState _locationTrackerWidgetState;

  @override
  void initState() {
    super.initState();
    _locationTrackerWidgetState = LocationTrackerInhWidget.of(context);
    _locationTrackerBloc = _locationTrackerWidgetState.locationTrackerBloc;
    _locationTrackerWidgetController = _locationTrackerWidgetState.locationTrackerWidgetController;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationTrackerBloc, LocationTrackerState>(
      bloc: _locationTrackerBloc,
      builder: (context, state) {
        switch (state) {
          case LocationTracker$InitialState():
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          case LocationTracker$InProgressState():
            return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
          case LocationTracker$ErrorState():
            return const SliverFillRemaining(child: Center(child: Text(somethingWentWrong)));
          case LocationTracker$CompletedState():
            final currentStateModel = state.locationTrackerStateModel;
            return SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const TextWidget(text: "Рабочее время", size: 16, fontWeight: FontWeight.w500),
                  // const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: _locationTrackerWidgetController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          if (_locationTrackerWidgetController.isTracking)
                            SizedBox(
                              width: 130,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(mainAppColor),
                                ),
                                onPressed: () {
                                  if (_locationTrackerWidgetController.isPausing) {
                                    EasyLoading.showInfo("Пожалуйста подождите");
                                    return;
                                  }
                                  _locationTrackerWidgetController.changeIsPausing(true);
                                  _locationTrackerBloc.add(
                                    LocationTrackerEvent.pause(
                                      onMessage: (String message) {
                                        EasyLoading.showInfo(message);
                                      },
                                      onPause: () {
                                        _locationTrackerWidgetController.changeIsTracking(false);
                                        _locationTrackerWidgetController.changeIsPausing(false);
                                      },
                                    ),
                                  );
                                },
                                child: const Text("Пауза"),
                              ),
                            ),
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  _locationTrackerWidgetController.isTracking
                                      ? Colors.pink
                                      : mainAppColor,
                                ),
                              ),
                              onPressed: () {
                                if (_locationTrackerWidgetController.isTracking) {
                                  if (_locationTrackerWidgetController.isFinishing) {
                                    EasyLoading.showInfo("Пожалуйста подождите");
                                    return;
                                  }
                                  _locationTrackerWidgetController.changeIsFinishing(true);
                                  _locationTrackerBloc.add(
                                    LocationTrackerEvent.finish(
                                      onMessage: (String message) {
                                        EasyLoading.showInfo(message);
                                      },
                                      onFinish: () {
                                        _locationTrackerWidgetController.changeIsTracking(false);
                                        _locationTrackerWidgetController.changeIsFinishing(false);
                                      },
                                    ),
                                  );
                                } else {
                                  _locationTrackerWidgetState.startTracking();
                                }
                              },
                              child: Text(
                                _locationTrackerWidgetController.isTracking
                                    ? "Завершить"
                                    : "Начать",
                              ),
                            ),
                          ),

                          if (_locationTrackerWidgetController.isTracking)
                            SizedBox(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(mainAppColor),
                                ),
                                onPressed: () {
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CustomerScreen(
                                          appBar: AppBar(
                                            backgroundColor: mainAppColor,
                                            elevation: 0.0,
                                            title: const Text("Покупатели"),
                                          ),
                                          onCustomerTap: (customer) async {
                                            if (customer.sId == null) {
                                              EasyLoading.showInfo(sync);
                                              return;
                                            }

                                            final customerRoutes = [
                                              // ClientCreatorScreen(
                                              //   customer: customer,
                                              //   refreshParent: () {},
                                              // ),
                                              CustomerAddressesConfigurationWidget(
                                                customerSId: customer.sId!,
                                              ),
                                              CustomerAddressCreationConfigWidget(
                                                customerSId: customer.sId!,
                                                getLocation: true,
                                              ),
                                            ];
                                            for (final each in customerRoutes) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => each),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text("Добавить адресс к покупателю"),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
