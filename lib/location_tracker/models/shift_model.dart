import 'package:my_store/features/location_tracker/models/shift_detail_model.dart';

class ShiftModel {
  ShiftModel({
    this.id,
    this.userId,
    this.startedAt,
    this.endedAt,
    this.forceEnded,
    this.totalKm,
    this.totalWnoKm,
    this.manualCreated,
    this.manualUpdated,
    this.actualTotal,
    this.estimatedTotal,
    this.forcedCount,
    this.forcedTotal,
    this.shiftDetails,
  });

  final int? id;
  final int? userId;
  final String? startedAt;
  final String? endedAt;
  final bool? forceEnded;
  final double? totalKm;
  final double? totalWnoKm;
  final String? manualCreated;
  final String? manualUpdated;
  final double? actualTotal;
  final double? estimatedTotal;
  final bool? forcedCount;
  final double? forcedTotal;
  final List<ShiftDetailModel>? shiftDetails;

  factory ShiftModel.fromJson(final Map<String, dynamic> json) {
    List<ShiftDetailModel> shiftDetails = [];

    if (json.containsKey('shift_details')) {
      List<dynamic> dShiftDetails = json['shift_details'];
      shiftDetails = dShiftDetails.map((element) => ShiftDetailModel.fromJson(element)).toList();
    }

    return ShiftModel(
      id: json['id'],
      userId: json['user_id'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
      forceEnded: json['force_ended'] == 1 ? true : false,
      totalKm: double.tryParse("${json['total_km']}"),
      totalWnoKm: double.tryParse("${json['total_wno_km']}"),
      manualCreated: json['manual_created'],
      manualUpdated: json['manual_updated'],
      actualTotal: double.tryParse("${json['actual_total']}"),
      estimatedTotal: double.tryParse("${json['estimated_total']}"),
      forcedCount: json['forced_count'] == 1 ? true : false,
      forcedTotal: double.tryParse("${json['forced_total']}"),
      shiftDetails: shiftDetails,
    );
  }
}
