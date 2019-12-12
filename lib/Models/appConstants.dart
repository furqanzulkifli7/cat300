import 'package:flutter/material.dart';
import 'package:cat300/Models/userObjects.dart';

class AppConstants {

  static final String appName = 'Jom Rent';

  static final Color selectedIconColor = Colors.deepOrange;
  static final Color nonSelectedIconColor = Colors.black;

  static User currentUser;

  static final Map<int, String> monthDict = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  static final Map<int, int> daysInMonths = {
    1: 31,
    2: DateTime.now().year % 4 == 0 ? 29: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };

}