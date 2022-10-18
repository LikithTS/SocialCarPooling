

import 'package:flutter/material.dart';

import '../../../util/constant.dart';
import 'add_car_home_view.dart';
import 'car_home_view.dart';
import 'profile_home_card.dart';
import 'questionnaire_home_card.dart';
import 'recent_rides_card.dart';
import 'upcoming_rides_card.dart';

Widget loadHomePageData(data) {
  return Column(
    children: [
      UpcomingRides(
        carIcon: 'assets/images/car_pool.png',
        startAddress: data.upcomingRides?.firstWhere((element) => true).startDestinationFormattedAddress ?? "",
        endAddress: data.upcomingRides?.firstWhere((element) => true).endDestinationFormattedAddress ?? "",
        rideType:  data.upcomingRides?.firstWhere((element) => true).rideType ?? Constant.AS_HOST,
        amount: data.upcomingRides?.firstWhere((element) => true).amountPerSeat ?? 0,
        dateTime: DateTime.now(),
        seatsOffered: data.upcomingRides?.firstWhere((element) => true).seatsOffered ?? 1,
        carType: data.upcomingRides?.firstWhere((element) => true).carTypeInterested ?? Constant.CAR_TYPE_SEDAN,
        coRidersCount: "2",
        leftButtonText: Constant.BUTTON_CANCEL,
        rideStatus: Constant.RIDE_SCHEDULED,
      ),
      RecentRides(
        carIcon: 'assets/images/car_pool.png',
        startAddress: data.recentRides?.firstWhere((element) => true).startDestinationFormattedAddress ?? "",
        endAddress: data.recentRides?.firstWhere((element) => true).endDestinationFormattedAddress ?? "",
        rideType: data.recentRides?.firstWhere((element) => true).rideType ?? Constant.AS_HOST,
        amount: data.recentRides?.firstWhere((element) => true).amountPerSeat ?? 0,
        dateTime: DateTime.now(),
        seatsOffered: data.recentRides?.firstWhere((element) => true).seatsOffered ?? 1,
        carType: Constant.CAR_TYPE_SEDAN,
        coRidersCount: "2",
        leftButtonText: Constant.BUTTON_CANCEL,
        rideStatus: Constant.RIDE_COMPLETED,
      ),
      if (data.questionnarie?.visibilityStatus ?? false) ...[
        const QuestionnaireCard(
            questionnairesCompletionPercentage: 0.30),
      ],
      ProfileCard(
          profileName: data.profile?.name ?? "",
          profileCompletionPercentage: data.profile?.percentageOfCompletion ??  100),
      HomeCarCard(
          carType: data.myCars?.firstWhere((element) => true).carType ?? Constant.CAR_TYPE_MINI,
          carName: data.myCars?.firstWhere((element) => true).carName ?? "",
          carNumber: data.myCars?.firstWhere((element) => true).regNumber ?? "",
          numberOfSeatsOffered: data.myCars?.firstWhere((element) => true).offeringSeat ?? 2,
          numberOfSeatsAvailable: data.myCars?.firstWhere((element) => true).seatingCapacity ?? 2,
          defaultStatus: true),
      const AddCarCard()
    ],
  );
}