
class DeleteCarApi {
  DeleteCarApi({
    String? carId,
  }) {
    _carId = carId;
  }

  DeleteCarApi.fromJson(dynamic json) {
    _carId = json['carId'];
  }

  String? _carId;

  String? get carId => _carId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['carId'] = _carId;
    return map;
  }
}
