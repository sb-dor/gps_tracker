import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_tracker/src/common/utils/extensions/string_extension.dart';
import 'package:logger/logger.dart';

class BlocObserverManager extends BlocObserver {
  const BlocObserverManager({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void onTransition(Bloc<Object?, Object?> bloc, Transition<Object?, Object?> transition) {
    final logMessage =
        StringBuffer()
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..writeln('Event: ${transition.event.runtimeType}')
          ..writeln(
            'Transition: ${transition.currentState.runtimeType} => '
            '${transition.nextState.runtimeType}',
          )
          ..write('New State: ${transition.nextState?.toString().limit(100)}');

    _logger.log(Level.info, logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage =
        StringBuffer()
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..writeln('Event: ${event.runtimeType}')
          ..write('Details: ${event?.toString().limit(200)}');

    _logger.log(Level.info, logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage =
        StringBuffer()
          ..writeln('Error from bloc: ${bloc.runtimeType}')
          ..writeln(error.toString());

    // you can also send bloc errors to server here

    _logger.log(Level.error, logMessage.toString(), error: error, stackTrace: stackTrace);

    // Avoid calling super.onError to prevent propagation
    // super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    final logMessage = StringBuffer()..writeln('Closed Bloc: ${bloc.runtimeType}');

    _logger.log(Level.info, logMessage.toString());
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    final logMessage = StringBuffer()..writeln('Opened Bloc: ${bloc.runtimeType}');

    _logger.log(Level.info, logMessage.toString());
    super.onCreate(bloc);
  }
}
