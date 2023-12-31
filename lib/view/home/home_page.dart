import 'dart:async';
import 'dart:developer';

import 'package:common/network/repository/HomeRepository.dart';
import 'package:common/network/response/HomeResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socialcarpooling/util/FirebaseNotification.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/widgets/widget_text.dart';
import 'package:socialcarpooling/view/home/BorderIcon.dart';
import 'package:socialcarpooling/view/home/home_drawer/navigation_drawer_widget.dart';
import 'package:socialcarpooling/view/map/map_screen.dart';
import 'package:socialcarpooling/view/notifications/notification_main_screen.dart';

import '../../util/color.dart';
import '../../util/Localization.dart';
import '../../widgets/button_widgets.dart';
import 'home_cards/driver_widget_view.dart';
import 'home_cards/home_screen_res_view.dart';
import 'home_cards/rider_widget_view.dart';

final GlobalKey<ScaffoldState> homeGlobalkey = GlobalKey();

class HomePage extends StatefulWidget {
  final HomeRepository homeRepository;

  const HomePage({Key? key, required this.homeRepository}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;

  double? latitude;
  double? longitude;
  late LatLng currentPosition;
  HomeRepository get _homeRepository => widget.homeRepository;
  FirebaseNotification firebaseNotification = FirebaseNotification();
  late Future<dynamic> homeDataFuture;

  // void getLocation() async {
  //   Position position = await getGeoLocationCoOrdinates();
  //   setState(() {
  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //   });
  // }

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

  late HomeResponse homeResponseData;

  @override
  void initState() {
    firebaseNotification.registerNotification();
    firebaseNotification.handleBackgroundNotification();
    firebaseNotification.checkForInitialMessage();
    homeDataFuture = _homeRepository.home();
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
          key: homeGlobalkey,
          drawer: const NavigationDrawerWidget(),
          body: Container(
            child: Stack(
              children: [
                Container(
                    height: deviceHeight(context) * .48,
                    //Load Maps here
                    child: const MapScreen(gpsIconShow: true)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        BorderIcon(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: const Icon(Icons.menu),
                            color: primaryColor,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              homeGlobalkey.currentState?.openDrawer();
                            },
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: false,
                          child: BorderIcon(
                            height: 50,
                            width: 50,
                            child: IconButton(
                              icon: const Icon(Icons.message),
                              color: primaryColor,
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                            ),
                          ),
                        ),
                        addHorizontalSpace(10),
                        BorderIcon(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: const Icon(Icons.notifications),
                            padding: EdgeInsets.zero,
                            color: primaryColor,
                            onPressed: () {
                              //For top Menu
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationMainScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  initialChildSize: 0.5,
                  builder: (BuildContext context,
                      ScrollController myScrollController) {
                    return ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      child: Container(
                        color: homePageBackgroundColor,
                        child: SingleChildScrollView(
                          controller: myScrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 30),
                                  height: 2,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: greyColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: TabBar(
                                    unselectedLabelColor: greyColor,
                                    unselectedLabelStyle: TextStyle(
                                        color: greyColor,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.sp),
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.sp),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      shape: BoxShape.rectangle,
                                      color: primaryColor,
                                      // Other flags
                                      // indicatorRadius: 1,
                                      // insets: EdgeInsets.all(1),
                                      // padding: EdgeInsets.all(10)
                                    ),
                                    controller: tabController,
                                    tabs: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            DemoLocalizations.of(context)!
                                                .getText("driver_tab")),
                                      ),
                                      Text(DemoLocalizations.of(context)!
                                          .getText("as_rider"))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    height: 320,
                                    child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          DriverWidgetView(refreshHomePage: () => refreshHomePageApi()),
                                          RiderWidgetView(refreshHomePage: () => refreshHomePageApi())
                                        ]),
                                  ),
                                ),
                                FutureBuilder<dynamic>(
                                  future: homeDataFuture, // a Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return const Text('No Internet!!');
                                      case ConnectionState.waiting:
                                        return const Text(
                                            'Please wait... Loading details');
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return loadHomePageData(snapshot.data,
                                              () => refreshScreen());
                                        }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    ));
  }

  Widget buildNavigationDrawer() => Column(
        children: [
          Text(
            DemoLocalizations.of(context)!.getText("home"),
            style: const TextStyle(color: primaryColor),
          )
        ],
      );
  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              DemoLocalizations.of(context)?.getText("really") ?? "",
              textAlign: TextAlign.start,
            ),
            content: Text(
                DemoLocalizations.of(context)
                        ?.getText("close_app_alert_desc") ??
                    "",
                textAlign: TextAlign.start),
            actions: [
              TextButton(
                child: Text(
                  DemoLocalizations.of(context)?.getText("no") ?? "",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'assets/fonts/poppins_medium.ttf'),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              primaryButtonWithCallBack(
                DemoLocalizations.of(context)?.getText("yes") ?? "",
                () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
    return exitApp ?? false;
  }

  refreshScreen() {
    // Refresh home screen data
    setState(() {
      log("Refresh move screen data");
    });
  }

  refreshHomePageApi() {
    homeDataFuture = _homeRepository.home();
    setState(() {
      log("Refresh move screen data");
    });
  }
}
