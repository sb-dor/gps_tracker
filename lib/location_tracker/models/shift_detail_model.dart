class ShiftDetailModel {
  ShiftDetailModel({this.id, this.shiftId, this.offlineAt, this.onlineAt});

  factory ShiftDetailModel.fromJson(final Map<String, dynamic> json) {
    return ShiftDetailModel(
      id: json['id'],
      shiftId: json['shift_id'],
      offlineAt: json['offlined_at'],
      onlineAt: json['onlined_at'],
    );
  }

  final int? id;
  final int? shiftId;
  final String? offlineAt;
  final String? onlineAt;
}
