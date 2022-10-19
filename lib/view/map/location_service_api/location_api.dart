import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/utils.dart';
import 'package:socialcarpooling/model/places.dart';

class LocationApi extends ChangeNotifier {
  List<Place> placeList = [];

  var addressController = TextEditingController();

  var _delay = Deley(milliSeconds: 500);

  final _controller = StreamController<List<Place>>.broadcast();

  Stream<List<Place>> get controllerOut =>
      _controller.stream.asBroadcastStream();

  StreamSink<List<Place>> get controllerIn => _controller.sink;

  addPlace(Place place){
    placeList.add(place);
    controllerIn.add(placeList);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  handleSearch(String query) async {
    if (query.length > 6) {
      _delay.run(() async {
        try {
          List<Location> location = await locationFromAddress(query);
          location.forEach((location) async {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
                location.latitude, location.longitude);
            placeMarks.forEach((placeMaker) {
             addPlace(Place(
                  name: placeMaker.name!,
                  street: placeMaker.street!,
                  locality: placeMaker.locality!,
                  country: placeMaker.country!,latitude:location.latitude,longitude: location.longitude));
            });
          });
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    }
    else
      {
        placeList.clear();
      }
  }
}

class Deley {
  final int milliSeconds;
  late VoidCallback action;
  Timer _timer = Timer(Duration(milliseconds: 500), () {});

  Deley({required this.milliSeconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSeconds), action);
  }
}
