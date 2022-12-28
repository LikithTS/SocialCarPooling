import 'package:common/network/model/MyCars.dart';
import 'package:common/network/model/Profile.dart';
import 'package:common/network/model/StartLocation.dart';

class AsDriver {
  String? id;
  String? driverUserId;
  String? carId;
  int? amountPerSeat;
  String? distance;
  String? duration;
  StartLocation? startLocation;
  String? startDestinationFormattedAddress;
  String? startDestinationPlaceId;
  int? seatsOffered;
  String? startTime;
  String? endDestinationFormattedAddress;
  StartLocation? endLocation;
  String? endDestinationPlaceId;
  String? rideStatus;
  Profile? user;
  MyCars? car;
  String? riderUserId;
  String? carTypeInterested;
  String? driverRideId;

  AsDriver(
      {this.id,
        this.driverUserId,
        this.carId,
        this.amountPerSeat,
        this.distance,
        this.duration,
        this.startLocation,
        this.startDestinationFormattedAddress,
        this.startDestinationPlaceId,
        this.seatsOffered,
        this.startTime,
        this.endDestinationFormattedAddress,
        this.endLocation,
        this.endDestinationPlaceId,
        this.rideStatus,
        this.riderUserId,
        this.carTypeInterested,
        this.driverRideId,
        this.user,
        this.car});

  AsDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverUserId = json['driverUserId'];
    carId = json['carId'];
    amountPerSeat = json['amountPerSeat'];
    distance = json['distance'];
    duration = json['duration'];
    startLocation = json['startLocation'] != null
        ? new StartLocation.fromJson(json['startLocation'])
        : null;
    startDestinationFormattedAddress = json['startDestinationFormattedAddress'];
    startDestinationPlaceId = json['startDestinationPlaceId'];
    seatsOffered = json['seatsOffered'];
    startTime = json['startTime'];
    endDestinationFormattedAddress = json['endDestinationFormattedAddress'];
    endLocation = json['endLocation'] != null
        ? new StartLocation.fromJson(json['endLocation'])
        : null;
    endDestinationPlaceId = json['endDestinationPlaceId'];
    rideStatus = json['rideStatus'];
    user = json['user'] != null ? new Profile.fromJson(json['user']) : null;
    car = json['car'] != null ? new MyCars.fromJson(json['car']) : null;
    riderUserId = json['riderUserId'];
    carTypeInterested = json['carTypeInterested'];
    driverRideId = json['driverRideId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverUserId'] = this.driverUserId;
    data['carId'] = this.carId;
    data['amountPerSeat'] = this.amountPerSeat;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    if (this.startLocation != null) {
      data['startLocation'] = this.startLocation!.toJson();
    }
    data['startDestinationFormattedAddress'] =
        this.startDestinationFormattedAddress;
    data['startDestinationPlaceId'] = this.startDestinationPlaceId;
    data['seatsOffered'] = this.seatsOffered;
    data['startTime'] = this.startTime;
    data['endDestinationFormattedAddress'] =
        this.endDestinationFormattedAddress;
    if (this.endLocation != null) {
      data['endLocation'] = this.endLocation!.toJson();
    }
    data['endDestinationPlaceId'] = this.endDestinationPlaceId;
    data['rideStatus'] = this.rideStatus;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    data['riderUserId'] = this.riderUserId;
    data['carTypeInterested'] = this.carTypeInterested;
    data['driverRideId'] = this.driverRideId;
    return data;
  }
}
