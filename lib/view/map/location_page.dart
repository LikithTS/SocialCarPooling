import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialcarpooling/provider/address_provider.dart';
import 'package:socialcarpooling/provider/driver_provider.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/color.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/view/map/search_location_view.dart';
import 'package:socialcarpooling/widgets/button_widgets.dart';

import '../../provider/provider_preference.dart';
import '../../util/CPString.dart';
import '../../util/font_size.dart';
import '../../util/margin_confiq.dart';

class LocationPage extends StatefulWidget {
  final bool flagAddress;
  final String userType;

  const LocationPage(
      {Key? key, required this.flagAddress, required this.userType})
      : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  static const _initialCameraPosition =
  CameraPosition(target: LatLng(13.0827, 80.2707), zoom: 14);
  late GoogleMapController _googleMapController;
  Marker? currentLocation;

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  double? latitude;
  double? longitude;
  late LatLng currentPosition;



  void getGpsLocation() async {
    Position position = await getGeoLocationCoOrdinates();
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        )));
    var places = await GeocodingPlatform.instance.placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "en");

    setState(() {
      currentLocation = Marker(
          markerId: MarkerId('currentLocation'),
          infoWindow: InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(position.latitude, position.longitude));
      ProviderPreference().putAddress(context,
          '${places[0].name} , ${places[0].street} , ${places[0].locality}, ${places[0].postalCode}');
    });
  }

  @override
  void initState() {
    super.initState();
    getGpsLocation();
  }

  Future<Position> getGeoLocationCoOrdinates() async {
    bool isServiceEnabled;
    LocationPermission permission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location Services are not enabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are not enabled');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission are denied permanently');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    var address = Provider
        .of<AddressProvider>(context)
        .address;
    var latLngProvider = Provider
        .of<AddressProvider>(context)
        .latLng;
    List<String> result = address.split(',');


    if(latLngProvider.latitude!=0.0)
      {
        _addMarker(latLngProvider);
      }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) =>
                _googleMapController = controller,
                markers: {
                  if (currentLocation != null) currentLocation!,
                },
                //onLongPress: _addMarker,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10)),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SearchLocationView(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 200),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10)),
                  child: Icon(
                    Icons.my_location,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Navigator.pop(context);
                   /* ProviderPreference().putLatLng(
                        context,
                        LatLng(0.0, 0.0));*/
                    getGpsLocation();
                  },
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  width: deviceWidth(context),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            result[0],
                            style: TextStyleUtils.primaryTextBold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            address,
                            style: TextStyleUtils.primaryTextRegular.copyWith(
                                fontSize: 14,
                                color: lightGreyColor,
                                height: 1.3),
                          )),
                      Container(
                        width: deviceWidth(context),
                        height: 70,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.userType.toString() == 'driver'
                                ? Provider.of<DriverProvider>(context,
                                listen: false)
                                .changeDriver(false)
                                : Provider.of<DriverProvider>(context,
                                listen: false)
                                .changeDriver(true);

                            var startLat = Provider
                                .of<AddressProvider>(context,
                                listen: false)
                                .driverStartLatLng;
                            //print("Start Lat : $startLat");

                            widget.flagAddress
                                ? widget.userType.toString() == 'driver'
                                ? ProviderPreference()
                                .putStartDriverAddress(context, address)
                                : ProviderPreference()
                                .putStartRiderAddress(context, address)
                                : widget.userType.toString() == 'driver'
                                ? ProviderPreference()
                                .putEndDriverAddress(context, address)
                                : ProviderPreference()
                                .putEndRiderAddress(context, address);
                            widget.flagAddress
                                ? widget.userType.toString() == 'driver'
                                ? ProviderPreference().putDriverStartLatLng(
                                context, latLngProvider)
                                : ProviderPreference().putRiderStartLatLng(
                                context, latLngProvider)
                                : widget.userType.toString() == 'driver'
                                ? ProviderPreference().putDriverDestLatLng(
                                context, latLngProvider)
                                : ProviderPreference().putRiderDestLatLng(
                                context, latLngProvider);

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(margin10),
                            ),
                            elevation: margin2,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              CPString.confirmLocation,
                              style: TextStyle(fontSize: fontSize18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _gotoChangePage() {
    /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        HomePage()), (Route<dynamic> route) => false);*/
  }

  void _addMarker(LatLng pos) async {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      // on below line we have given positions of Location 5
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 14,
        )));
    setState(() {
      currentLocation = Marker(
          markerId: MarkerId('orgin'),
          infoWindow: InfoWindow(title: 'Orgin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
          position: pos);
    });
  }
}
