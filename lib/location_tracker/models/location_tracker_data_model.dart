import 'package:location/location.dart';

class LocationTrackerDataModel {
  //
  LocationTrackerDataModel({this.locationData, this.parsedDateTime, this.distance});

  factory LocationTrackerDataModel.fromMap(final Map<String, dynamic> json) {
    return LocationTrackerDataModel(
      locationData: LocationData.fromMap(json),
      parsedDateTime: DateTime.tryParse(json['visited_at'].toString()),
      distance: json['distance'],
    );
  }

  final LocationData? locationData;
  final DateTime? parsedDateTime;
  final double? distance;

  Map<String, dynamic> toJson() => {
    "visited_at": parsedDateTime.toString(),
    "lat": locationData?.latitude,
    "lon": locationData?.longitude,
  };

  Map<String, dynamic> toDb() => {
    "visited_at": parsedDateTime.toString(),
    "latitude": locationData?.latitude,
    "longitude": locationData?.longitude,
    "distance": distance,
  };
}
