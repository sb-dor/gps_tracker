// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_tracker_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationTrackerEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTrackerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent()';
}


}

/// @nodoc
class $LocationTrackerEventCopyWith<$Res>  {
$LocationTrackerEventCopyWith(LocationTrackerEvent _, $Res Function(LocationTrackerEvent) __);
}


/// @nodoc


class _LocationTracker$InitialEvent extends LocationTrackerEvent with DiagnosticableTreeMixin {
  const _LocationTracker$InitialEvent({required this.locationWidgetController, required this.startTracking}): super._();
  

 final  LocationTrackerWidgetController locationWidgetController;
 final   Function({bool checkIsStarting}) startTracking;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationTracker$InitialEventCopyWith<_LocationTracker$InitialEvent> get copyWith => __$LocationTracker$InitialEventCopyWithImpl<_LocationTracker$InitialEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent.initial'))
    ..add(DiagnosticsProperty('locationWidgetController', locationWidgetController))..add(DiagnosticsProperty('startTracking', startTracking));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationTracker$InitialEvent&&(identical(other.locationWidgetController, locationWidgetController) || other.locationWidgetController == locationWidgetController)&&(identical(other.startTracking, startTracking) || other.startTracking == startTracking));
}


@override
int get hashCode => Object.hash(runtimeType,locationWidgetController,startTracking);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent.initial(locationWidgetController: $locationWidgetController, startTracking: $startTracking)';
}


}

/// @nodoc
abstract mixin class _$LocationTracker$InitialEventCopyWith<$Res> implements $LocationTrackerEventCopyWith<$Res> {
  factory _$LocationTracker$InitialEventCopyWith(_LocationTracker$InitialEvent value, $Res Function(_LocationTracker$InitialEvent) _then) = __$LocationTracker$InitialEventCopyWithImpl;
@useResult
$Res call({
 LocationTrackerWidgetController locationWidgetController,  Function({bool checkIsStarting}) startTracking
});




}
/// @nodoc
class __$LocationTracker$InitialEventCopyWithImpl<$Res>
    implements _$LocationTracker$InitialEventCopyWith<$Res> {
  __$LocationTracker$InitialEventCopyWithImpl(this._self, this._then);

  final _LocationTracker$InitialEvent _self;
  final $Res Function(_LocationTracker$InitialEvent) _then;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locationWidgetController = null,Object? startTracking = null,}) {
  return _then(_LocationTracker$InitialEvent(
locationWidgetController: null == locationWidgetController ? _self.locationWidgetController : locationWidgetController // ignore: cast_nullable_to_non_nullable
as LocationTrackerWidgetController,startTracking: null == startTracking ? _self.startTracking : startTracking // ignore: cast_nullable_to_non_nullable
as  Function({bool checkIsStarting}),
  ));
}


}

/// @nodoc


class _LocationTracker$StartEvent extends LocationTrackerEvent with DiagnosticableTreeMixin {
  const _LocationTracker$StartEvent({required this.onMessage, required this.onStart, required this.onFinish}): super._();
  

 final  void Function(String message) onMessage;
 final  void Function() onStart;
 final  void Function() onFinish;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationTracker$StartEventCopyWith<_LocationTracker$StartEvent> get copyWith => __$LocationTracker$StartEventCopyWithImpl<_LocationTracker$StartEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent.start'))
    ..add(DiagnosticsProperty('onMessage', onMessage))..add(DiagnosticsProperty('onStart', onStart))..add(DiagnosticsProperty('onFinish', onFinish));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationTracker$StartEvent&&(identical(other.onMessage, onMessage) || other.onMessage == onMessage)&&(identical(other.onStart, onStart) || other.onStart == onStart)&&(identical(other.onFinish, onFinish) || other.onFinish == onFinish));
}


@override
int get hashCode => Object.hash(runtimeType,onMessage,onStart,onFinish);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent.start(onMessage: $onMessage, onStart: $onStart, onFinish: $onFinish)';
}


}

/// @nodoc
abstract mixin class _$LocationTracker$StartEventCopyWith<$Res> implements $LocationTrackerEventCopyWith<$Res> {
  factory _$LocationTracker$StartEventCopyWith(_LocationTracker$StartEvent value, $Res Function(_LocationTracker$StartEvent) _then) = __$LocationTracker$StartEventCopyWithImpl;
@useResult
$Res call({
 void Function(String message) onMessage, void Function() onStart, void Function() onFinish
});




}
/// @nodoc
class __$LocationTracker$StartEventCopyWithImpl<$Res>
    implements _$LocationTracker$StartEventCopyWith<$Res> {
  __$LocationTracker$StartEventCopyWithImpl(this._self, this._then);

  final _LocationTracker$StartEvent _self;
  final $Res Function(_LocationTracker$StartEvent) _then;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? onMessage = null,Object? onStart = null,Object? onFinish = null,}) {
  return _then(_LocationTracker$StartEvent(
onMessage: null == onMessage ? _self.onMessage : onMessage // ignore: cast_nullable_to_non_nullable
as void Function(String message),onStart: null == onStart ? _self.onStart : onStart // ignore: cast_nullable_to_non_nullable
as void Function(),onFinish: null == onFinish ? _self.onFinish : onFinish // ignore: cast_nullable_to_non_nullable
as void Function(),
  ));
}


}

/// @nodoc


class _LocationTracker$PauseEvent extends LocationTrackerEvent with DiagnosticableTreeMixin {
  const _LocationTracker$PauseEvent({required this.onMessage, required this.onPause}): super._();
  

 final  void Function(String message) onMessage;
 final  void Function() onPause;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationTracker$PauseEventCopyWith<_LocationTracker$PauseEvent> get copyWith => __$LocationTracker$PauseEventCopyWithImpl<_LocationTracker$PauseEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent.pause'))
    ..add(DiagnosticsProperty('onMessage', onMessage))..add(DiagnosticsProperty('onPause', onPause));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationTracker$PauseEvent&&(identical(other.onMessage, onMessage) || other.onMessage == onMessage)&&(identical(other.onPause, onPause) || other.onPause == onPause));
}


@override
int get hashCode => Object.hash(runtimeType,onMessage,onPause);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent.pause(onMessage: $onMessage, onPause: $onPause)';
}


}

/// @nodoc
abstract mixin class _$LocationTracker$PauseEventCopyWith<$Res> implements $LocationTrackerEventCopyWith<$Res> {
  factory _$LocationTracker$PauseEventCopyWith(_LocationTracker$PauseEvent value, $Res Function(_LocationTracker$PauseEvent) _then) = __$LocationTracker$PauseEventCopyWithImpl;
@useResult
$Res call({
 void Function(String message) onMessage, void Function() onPause
});




}
/// @nodoc
class __$LocationTracker$PauseEventCopyWithImpl<$Res>
    implements _$LocationTracker$PauseEventCopyWith<$Res> {
  __$LocationTracker$PauseEventCopyWithImpl(this._self, this._then);

  final _LocationTracker$PauseEvent _self;
  final $Res Function(_LocationTracker$PauseEvent) _then;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? onMessage = null,Object? onPause = null,}) {
  return _then(_LocationTracker$PauseEvent(
onMessage: null == onMessage ? _self.onMessage : onMessage // ignore: cast_nullable_to_non_nullable
as void Function(String message),onPause: null == onPause ? _self.onPause : onPause // ignore: cast_nullable_to_non_nullable
as void Function(),
  ));
}


}

/// @nodoc


class _LocationTracker$CurrentLocationEvent extends LocationTrackerEvent with DiagnosticableTreeMixin {
  const _LocationTracker$CurrentLocationEvent({required this.onMessage}): super._();
  

 final  void Function(String message) onMessage;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationTracker$CurrentLocationEventCopyWith<_LocationTracker$CurrentLocationEvent> get copyWith => __$LocationTracker$CurrentLocationEventCopyWithImpl<_LocationTracker$CurrentLocationEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent.currentLocation'))
    ..add(DiagnosticsProperty('onMessage', onMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationTracker$CurrentLocationEvent&&(identical(other.onMessage, onMessage) || other.onMessage == onMessage));
}


@override
int get hashCode => Object.hash(runtimeType,onMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent.currentLocation(onMessage: $onMessage)';
}


}

/// @nodoc
abstract mixin class _$LocationTracker$CurrentLocationEventCopyWith<$Res> implements $LocationTrackerEventCopyWith<$Res> {
  factory _$LocationTracker$CurrentLocationEventCopyWith(_LocationTracker$CurrentLocationEvent value, $Res Function(_LocationTracker$CurrentLocationEvent) _then) = __$LocationTracker$CurrentLocationEventCopyWithImpl;
@useResult
$Res call({
 void Function(String message) onMessage
});




}
/// @nodoc
class __$LocationTracker$CurrentLocationEventCopyWithImpl<$Res>
    implements _$LocationTracker$CurrentLocationEventCopyWith<$Res> {
  __$LocationTracker$CurrentLocationEventCopyWithImpl(this._self, this._then);

  final _LocationTracker$CurrentLocationEvent _self;
  final $Res Function(_LocationTracker$CurrentLocationEvent) _then;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? onMessage = null,}) {
  return _then(_LocationTracker$CurrentLocationEvent(
onMessage: null == onMessage ? _self.onMessage : onMessage // ignore: cast_nullable_to_non_nullable
as void Function(String message),
  ));
}


}

/// @nodoc


class _LocationTracker$FinishEvent extends LocationTrackerEvent with DiagnosticableTreeMixin {
  const _LocationTracker$FinishEvent({required this.onMessage, required this.onFinish}): super._();
  

 final  void Function(String message) onMessage;
 final  void Function() onFinish;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationTracker$FinishEventCopyWith<_LocationTracker$FinishEvent> get copyWith => __$LocationTracker$FinishEventCopyWithImpl<_LocationTracker$FinishEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerEvent.finish'))
    ..add(DiagnosticsProperty('onMessage', onMessage))..add(DiagnosticsProperty('onFinish', onFinish));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationTracker$FinishEvent&&(identical(other.onMessage, onMessage) || other.onMessage == onMessage)&&(identical(other.onFinish, onFinish) || other.onFinish == onFinish));
}


@override
int get hashCode => Object.hash(runtimeType,onMessage,onFinish);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerEvent.finish(onMessage: $onMessage, onFinish: $onFinish)';
}


}

/// @nodoc
abstract mixin class _$LocationTracker$FinishEventCopyWith<$Res> implements $LocationTrackerEventCopyWith<$Res> {
  factory _$LocationTracker$FinishEventCopyWith(_LocationTracker$FinishEvent value, $Res Function(_LocationTracker$FinishEvent) _then) = __$LocationTracker$FinishEventCopyWithImpl;
@useResult
$Res call({
 void Function(String message) onMessage, void Function() onFinish
});




}
/// @nodoc
class __$LocationTracker$FinishEventCopyWithImpl<$Res>
    implements _$LocationTracker$FinishEventCopyWith<$Res> {
  __$LocationTracker$FinishEventCopyWithImpl(this._self, this._then);

  final _LocationTracker$FinishEvent _self;
  final $Res Function(_LocationTracker$FinishEvent) _then;

/// Create a copy of LocationTrackerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? onMessage = null,Object? onFinish = null,}) {
  return _then(_LocationTracker$FinishEvent(
onMessage: null == onMessage ? _self.onMessage : onMessage // ignore: cast_nullable_to_non_nullable
as void Function(String message),onFinish: null == onFinish ? _self.onFinish : onFinish // ignore: cast_nullable_to_non_nullable
as void Function(),
  ));
}


}

/// @nodoc
mixin _$LocationTrackerState implements DiagnosticableTreeMixin {

 LocationTrackerStateModel get locationTrackerStateModel;
/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationTrackerStateCopyWith<LocationTrackerState> get copyWith => _$LocationTrackerStateCopyWithImpl<LocationTrackerState>(this as LocationTrackerState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerState'))
    ..add(DiagnosticsProperty('locationTrackerStateModel', locationTrackerStateModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTrackerState&&(identical(other.locationTrackerStateModel, locationTrackerStateModel) || other.locationTrackerStateModel == locationTrackerStateModel));
}


@override
int get hashCode => Object.hash(runtimeType,locationTrackerStateModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerState(locationTrackerStateModel: $locationTrackerStateModel)';
}


}

/// @nodoc
abstract mixin class $LocationTrackerStateCopyWith<$Res>  {
  factory $LocationTrackerStateCopyWith(LocationTrackerState value, $Res Function(LocationTrackerState) _then) = _$LocationTrackerStateCopyWithImpl;
@useResult
$Res call({
 LocationTrackerStateModel locationTrackerStateModel
});




}
/// @nodoc
class _$LocationTrackerStateCopyWithImpl<$Res>
    implements $LocationTrackerStateCopyWith<$Res> {
  _$LocationTrackerStateCopyWithImpl(this._self, this._then);

  final LocationTrackerState _self;
  final $Res Function(LocationTrackerState) _then;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationTrackerStateModel = null,}) {
  return _then(_self.copyWith(
locationTrackerStateModel: null == locationTrackerStateModel ? _self.locationTrackerStateModel : locationTrackerStateModel // ignore: cast_nullable_to_non_nullable
as LocationTrackerStateModel,
  ));
}

}


/// @nodoc


class LocationTracker$InitialState extends LocationTrackerState with DiagnosticableTreeMixin {
  const LocationTracker$InitialState(this.locationTrackerStateModel): super._();
  

@override final  LocationTrackerStateModel locationTrackerStateModel;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationTracker$InitialStateCopyWith<LocationTracker$InitialState> get copyWith => _$LocationTracker$InitialStateCopyWithImpl<LocationTracker$InitialState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerState.initial'))
    ..add(DiagnosticsProperty('locationTrackerStateModel', locationTrackerStateModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTracker$InitialState&&(identical(other.locationTrackerStateModel, locationTrackerStateModel) || other.locationTrackerStateModel == locationTrackerStateModel));
}


@override
int get hashCode => Object.hash(runtimeType,locationTrackerStateModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerState.initial(locationTrackerStateModel: $locationTrackerStateModel)';
}


}

/// @nodoc
abstract mixin class $LocationTracker$InitialStateCopyWith<$Res> implements $LocationTrackerStateCopyWith<$Res> {
  factory $LocationTracker$InitialStateCopyWith(LocationTracker$InitialState value, $Res Function(LocationTracker$InitialState) _then) = _$LocationTracker$InitialStateCopyWithImpl;
@override @useResult
$Res call({
 LocationTrackerStateModel locationTrackerStateModel
});




}
/// @nodoc
class _$LocationTracker$InitialStateCopyWithImpl<$Res>
    implements $LocationTracker$InitialStateCopyWith<$Res> {
  _$LocationTracker$InitialStateCopyWithImpl(this._self, this._then);

  final LocationTracker$InitialState _self;
  final $Res Function(LocationTracker$InitialState) _then;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationTrackerStateModel = null,}) {
  return _then(LocationTracker$InitialState(
null == locationTrackerStateModel ? _self.locationTrackerStateModel : locationTrackerStateModel // ignore: cast_nullable_to_non_nullable
as LocationTrackerStateModel,
  ));
}


}

/// @nodoc


class LocationTracker$InProgressState extends LocationTrackerState with DiagnosticableTreeMixin {
  const LocationTracker$InProgressState(this.locationTrackerStateModel): super._();
  

@override final  LocationTrackerStateModel locationTrackerStateModel;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationTracker$InProgressStateCopyWith<LocationTracker$InProgressState> get copyWith => _$LocationTracker$InProgressStateCopyWithImpl<LocationTracker$InProgressState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerState.inProgress'))
    ..add(DiagnosticsProperty('locationTrackerStateModel', locationTrackerStateModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTracker$InProgressState&&(identical(other.locationTrackerStateModel, locationTrackerStateModel) || other.locationTrackerStateModel == locationTrackerStateModel));
}


@override
int get hashCode => Object.hash(runtimeType,locationTrackerStateModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerState.inProgress(locationTrackerStateModel: $locationTrackerStateModel)';
}


}

/// @nodoc
abstract mixin class $LocationTracker$InProgressStateCopyWith<$Res> implements $LocationTrackerStateCopyWith<$Res> {
  factory $LocationTracker$InProgressStateCopyWith(LocationTracker$InProgressState value, $Res Function(LocationTracker$InProgressState) _then) = _$LocationTracker$InProgressStateCopyWithImpl;
@override @useResult
$Res call({
 LocationTrackerStateModel locationTrackerStateModel
});




}
/// @nodoc
class _$LocationTracker$InProgressStateCopyWithImpl<$Res>
    implements $LocationTracker$InProgressStateCopyWith<$Res> {
  _$LocationTracker$InProgressStateCopyWithImpl(this._self, this._then);

  final LocationTracker$InProgressState _self;
  final $Res Function(LocationTracker$InProgressState) _then;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationTrackerStateModel = null,}) {
  return _then(LocationTracker$InProgressState(
null == locationTrackerStateModel ? _self.locationTrackerStateModel : locationTrackerStateModel // ignore: cast_nullable_to_non_nullable
as LocationTrackerStateModel,
  ));
}


}

/// @nodoc


class LocationTracker$ErrorState extends LocationTrackerState with DiagnosticableTreeMixin {
  const LocationTracker$ErrorState(this.locationTrackerStateModel): super._();
  

@override final  LocationTrackerStateModel locationTrackerStateModel;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationTracker$ErrorStateCopyWith<LocationTracker$ErrorState> get copyWith => _$LocationTracker$ErrorStateCopyWithImpl<LocationTracker$ErrorState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerState.error'))
    ..add(DiagnosticsProperty('locationTrackerStateModel', locationTrackerStateModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTracker$ErrorState&&(identical(other.locationTrackerStateModel, locationTrackerStateModel) || other.locationTrackerStateModel == locationTrackerStateModel));
}


@override
int get hashCode => Object.hash(runtimeType,locationTrackerStateModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerState.error(locationTrackerStateModel: $locationTrackerStateModel)';
}


}

/// @nodoc
abstract mixin class $LocationTracker$ErrorStateCopyWith<$Res> implements $LocationTrackerStateCopyWith<$Res> {
  factory $LocationTracker$ErrorStateCopyWith(LocationTracker$ErrorState value, $Res Function(LocationTracker$ErrorState) _then) = _$LocationTracker$ErrorStateCopyWithImpl;
@override @useResult
$Res call({
 LocationTrackerStateModel locationTrackerStateModel
});




}
/// @nodoc
class _$LocationTracker$ErrorStateCopyWithImpl<$Res>
    implements $LocationTracker$ErrorStateCopyWith<$Res> {
  _$LocationTracker$ErrorStateCopyWithImpl(this._self, this._then);

  final LocationTracker$ErrorState _self;
  final $Res Function(LocationTracker$ErrorState) _then;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationTrackerStateModel = null,}) {
  return _then(LocationTracker$ErrorState(
null == locationTrackerStateModel ? _self.locationTrackerStateModel : locationTrackerStateModel // ignore: cast_nullable_to_non_nullable
as LocationTrackerStateModel,
  ));
}


}

/// @nodoc


class LocationTracker$CompletedState extends LocationTrackerState with DiagnosticableTreeMixin {
  const LocationTracker$CompletedState(this.locationTrackerStateModel): super._();
  

@override final  LocationTrackerStateModel locationTrackerStateModel;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationTracker$CompletedStateCopyWith<LocationTracker$CompletedState> get copyWith => _$LocationTracker$CompletedStateCopyWithImpl<LocationTracker$CompletedState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LocationTrackerState.completed'))
    ..add(DiagnosticsProperty('locationTrackerStateModel', locationTrackerStateModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationTracker$CompletedState&&(identical(other.locationTrackerStateModel, locationTrackerStateModel) || other.locationTrackerStateModel == locationTrackerStateModel));
}


@override
int get hashCode => Object.hash(runtimeType,locationTrackerStateModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LocationTrackerState.completed(locationTrackerStateModel: $locationTrackerStateModel)';
}


}

/// @nodoc
abstract mixin class $LocationTracker$CompletedStateCopyWith<$Res> implements $LocationTrackerStateCopyWith<$Res> {
  factory $LocationTracker$CompletedStateCopyWith(LocationTracker$CompletedState value, $Res Function(LocationTracker$CompletedState) _then) = _$LocationTracker$CompletedStateCopyWithImpl;
@override @useResult
$Res call({
 LocationTrackerStateModel locationTrackerStateModel
});




}
/// @nodoc
class _$LocationTracker$CompletedStateCopyWithImpl<$Res>
    implements $LocationTracker$CompletedStateCopyWith<$Res> {
  _$LocationTracker$CompletedStateCopyWithImpl(this._self, this._then);

  final LocationTracker$CompletedState _self;
  final $Res Function(LocationTracker$CompletedState) _then;

/// Create a copy of LocationTrackerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationTrackerStateModel = null,}) {
  return _then(LocationTracker$CompletedState(
null == locationTrackerStateModel ? _self.locationTrackerStateModel : locationTrackerStateModel // ignore: cast_nullable_to_non_nullable
as LocationTrackerStateModel,
  ));
}


}

// dart format on
