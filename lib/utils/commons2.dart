import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/equipment_update.dart';
import 'package:new_app/utils/commons1.dart';
import 'package:new_app/utils/database_helper.dart';

bool res;
//Dashboard
List<DailyEngAvail> res1;
List<DailyEquipAvail> res2;
List<DailyEquipUtil> res3;

List<DailyEngAvail> resRange1;
List<DailyEquipAvail> resRange2;
List<DailyEquipUtil> resRange3;

List<DailyEngAvail> resMonth1;
List<DailyEquipAvail> resMonth2;
List<DailyEquipUtil> resMonth3;

//Day shift
List<DailyEngAvail> dayRes1;
List<DailyEquipAvail> dayRes2;
List<DailyEquipUtil> dayRes3;

List<DailyEngAvail> dayResRange1;
List<DailyEquipAvail> dayResRange2;
List<DailyEquipUtil> dayResRange3;

List<DailyEngAvail> dayResMonth1;
List<DailyEquipAvail> dayResMonth2;
List<DailyEquipUtil> dayResMonth3;

//Afternoon shift
List<DailyEngAvail> afternoonRes1;
List<DailyEquipAvail> afternoonRes2;
List<DailyEquipUtil> afternoonRes3;

List<DailyEngAvail> afternoonResRange1;
List<DailyEquipAvail> afternoonResRange2;
List<DailyEquipUtil> afternoonResRange3;

List<DailyEngAvail> afternoonResMonth1;
List<DailyEquipAvail> afternoonResMonth2;
List<DailyEquipUtil> afternoonResMonth3;

//Night shift
List<DailyEngAvail> nightRes1;
List<DailyEquipAvail> nightRes2;
List<DailyEquipUtil> nightRes3;

List<DailyEngAvail> nightResRange1;
List<DailyEquipAvail> nightResRange2;
List<DailyEquipUtil> nightResRange3;

List<DailyEngAvail> nightResMonth1;
List<DailyEquipAvail> nightResMonth2;
List<DailyEquipUtil> nightResMonth3;

//Equipment list data
List<EquipmentUpdate> dayEList;
List<EquipmentUpdate> rangeEList;
List<EquipmentUpdate> monthEList;

List<EquipmentUpdate> dayDayShiftEList;
List<EquipmentUpdate> rangeDayShiftEList;
List<EquipmentUpdate> monthDayShiftEList;

List<EquipmentUpdate> dayAfternoonShiftEList;
List<EquipmentUpdate> rangeAfternoonShiftEList;
List<EquipmentUpdate> monthAfternoonShiftEList;

List<EquipmentUpdate> dayNightShiftEList;
List<EquipmentUpdate> rangeNightShiftEList;
List<EquipmentUpdate> monthNightShiftEList;

final List<DailyEquipTarget> equipChartData = [
  DailyEquipTarget('Shovel', 95),
  DailyEquipTarget('Loader', 90),
  DailyEquipTarget('Drill', 85),
  DailyEquipTarget('Truck', 75)
];

//Get equipment data from db to graphs
Future<List<EquipmentUpdate>> getEquipmentData(DateTime date) async {
  await DatabaseHelper.db
      .getDailyEquipmentUpdate(DateFormat('dd-MM-yyyy').format(date))
      .then((value) async {
    dayEList = value;
    await getGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
  return dayEList;
}

Future<EquipmentUpdate> getDayEquipmentData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftEquipmentUpdate(DateFormat('dd-MM-yyyy').format(date), "Day")
      .then((value) async {
    dayDayShiftEList = value;
    await getDayGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

Future<EquipmentUpdate> getAfternoonEquipmentData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftEquipmentUpdate(
          DateFormat('dd-MM-yyyy').format(date), "Afternoon")
      .then((value) async {
    dayAfternoonShiftEList = value;
    await getAfternoonGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

Future<EquipmentUpdate> getNightEquipmentData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftEquipmentUpdate(DateFormat('dd-MM-yyyy').format(date), "Night")
      .then((value) async {
    dayNightShiftEList = value;
    await getNightGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

//Get ranged equipment data from db to graphs
Future<EquipmentUpdate> getRangeEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyEquipmentUpdate(getDaysInBeteween(date1, date2))
      .then((value) async {
    rangeEList = value;
    await getGraphValues2(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getDayRangeEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(getDaysInBeteween(date1, date2), "Day")
      .then((value) async {
    rangeDayShiftEList = value;
    await getDayGraphValues2(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getAfternoonRangeEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(
          getDaysInBeteween(date1, date2), "Afternoon")
      .then((value) async {
    rangeAfternoonShiftEList = value;
    await getAfternoonGraphValues2(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getNightRangeEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(getDaysInBeteween(date1, date2), "Night")
      .then((value) async {
    rangeNightShiftEList = value;
    await getNightGraphValues2(value, getDaysInBeteween(date1, date2));
  });
}

//Get monthly equipment data from db to graphs
Future<EquipmentUpdate> getMonthEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyEquipmentUpdate(getDaysInBeteween(date1, date2))
      .then((value) async {
    monthEList = value;
    await getGraphValues3(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getDayMonthEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(getDaysInBeteween(date1, date2), "Day")
      .then((value) async {
    monthDayShiftEList = value;
    await getDayGraphValues3(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getAfternoonMonthEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(
          getDaysInBeteween(date1, date2), "Afternoon")
      .then((value) async {
    monthAfternoonShiftEList = value;
    await getAfternoonGraphValues3(value, getDaysInBeteween(date1, date2));
  });
}

Future<EquipmentUpdate> getNightMonthEquipmentData(
    DateTime date1, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeEquipmentUpdate(getDaysInBeteween(date1, date2), "Night")
      .then((value) async {
    monthNightShiftEList = value;
    await getNightGraphValues3(value, getDaysInBeteween(date1, date2));
  });
}

//get graph details for one day
getGraphValues(List<EquipmentUpdate> list, String date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var i in list) {
    if (i.equipment == "Shovel" && i.date == date) {
      shovelEquipAvail += i.equipmentAvailability;
      shovelEngAvail += i.engineeringAvailability;
      shovelEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Loader" && i.date == date) {
      loaderEquipAvail += i.equipmentAvailability;
      loaderEngAvail += i.engineeringAvailability;
      loaderEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Drill" && i.date == date) {
      drillEquipAvail += i.equipmentAvailability;
      drillEngAvail += i.engineeringAvailability;
      drillEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Truck" && i.date == date) {
      truckEquipAvail += i.equipmentAvailability;
      truckEngAvail += i.engineeringAvailability;
      truckEquipUtil += i.equipmentUtilization;
    }
  }

  tres1.add(DailyEngAvail("Shovel", shovelEngAvail / 3, Colors.blueAccent));
  tres1.add(DailyEngAvail("Loader", loaderEngAvail / 3, Colors.blueAccent));
  tres1.add(DailyEngAvail("Drill", drillEngAvail / 3, Colors.blueAccent));
  tres1.add(DailyEngAvail("Truck", truckEngAvail / 3, Colors.blueAccent));

  tres2.add(DailyEquipAvail("Shovel", shovelEquipAvail / 3, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Loader", loaderEquipAvail / 3, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Drill", drillEquipAvail / 3, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Truck", truckEquipAvail / 3, Colors.pinkAccent));

  tres3.add(DailyEquipUtil("Shovel", shovelEquipUtil / 3, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Loader", loaderEquipUtil / 3, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Drill", drillEquipUtil / 3, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Truck", truckEquipUtil / 3, Colors.purpleAccent));

  res1 = tres1;
  res2 = tres2;
  res3 = tres3;
}

getDayGraphValues(List<EquipmentUpdate> list, String date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var i in list) {
    if (i.equipment == "Shovel" && i.date == date) {
      shovelEquipAvail += i.equipmentAvailability;
      shovelEngAvail += i.engineeringAvailability;
      shovelEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Loader" && i.date == date) {
      loaderEquipAvail += i.equipmentAvailability;
      loaderEngAvail += i.engineeringAvailability;
      loaderEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Drill" && i.date == date) {
      drillEquipAvail += i.equipmentAvailability;
      drillEngAvail += i.engineeringAvailability;
      drillEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Truck" && i.date == date) {
      truckEquipAvail += i.equipmentAvailability;
      truckEngAvail += i.engineeringAvailability;
      truckEquipUtil += i.equipmentUtilization;
    }
  }

  tres1.add(DailyEngAvail("Shovel", shovelEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Loader", loaderEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Drill", drillEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Truck", truckEngAvail, Colors.blueAccent));

  tres2.add(DailyEquipAvail("Shovel", shovelEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Loader", loaderEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Drill", drillEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Truck", truckEquipAvail, Colors.pinkAccent));

  tres3.add(DailyEquipUtil("Shovel", shovelEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Loader", loaderEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Drill", drillEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Truck", truckEquipUtil, Colors.purpleAccent));

  dayRes1 = tres1;
  dayRes2 = tres2;
  dayRes3 = tres3;
}

getAfternoonGraphValues(List<EquipmentUpdate> list, String date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var i in list) {
    if (i.equipment == "Shovel" && i.date == date) {
      shovelEquipAvail += i.equipmentAvailability;
      shovelEngAvail += i.engineeringAvailability;
      shovelEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Loader" && i.date == date) {
      loaderEquipAvail += i.equipmentAvailability;
      loaderEngAvail += i.engineeringAvailability;
      loaderEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Drill" && i.date == date) {
      drillEquipAvail += i.equipmentAvailability;
      drillEngAvail += i.engineeringAvailability;
      drillEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Truck" && i.date == date) {
      truckEquipAvail += i.equipmentAvailability;
      truckEngAvail += i.engineeringAvailability;
      truckEquipUtil += i.equipmentUtilization;
    }
  }

  tres1.add(DailyEngAvail("Shovel", shovelEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Loader", loaderEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Drill", drillEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Truck", truckEngAvail, Colors.blueAccent));

  tres2.add(DailyEquipAvail("Shovel", shovelEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Loader", loaderEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Drill", drillEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Truck", truckEquipAvail, Colors.pinkAccent));

  tres3.add(DailyEquipUtil("Shovel", shovelEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Loader", loaderEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Drill", drillEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Truck", truckEquipUtil, Colors.purpleAccent));

  afternoonRes1 = tres1;
  afternoonRes2 = tres2;
  afternoonRes3 = tres3;
}

getNightGraphValues(List<EquipmentUpdate> list, String date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var i in list) {
    if (i.equipment == "Shovel" && i.date == date) {
      shovelEquipAvail += i.equipmentAvailability;
      shovelEngAvail += i.engineeringAvailability;
      shovelEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Loader" && i.date == date) {
      loaderEquipAvail += i.equipmentAvailability;
      loaderEngAvail += i.engineeringAvailability;
      loaderEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Drill" && i.date == date) {
      drillEquipAvail += i.equipmentAvailability;
      drillEngAvail += i.engineeringAvailability;
      drillEquipUtil += i.equipmentUtilization;
    } else if (i.equipment == "Truck" && i.date == date) {
      truckEquipAvail += i.equipmentAvailability;
      truckEngAvail += i.engineeringAvailability;
      truckEquipUtil += i.equipmentUtilization;
    }
  }

  tres1.add(DailyEngAvail("Shovel", shovelEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Loader", loaderEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Drill", drillEngAvail, Colors.blueAccent));
  tres1.add(DailyEngAvail("Truck", truckEngAvail, Colors.blueAccent));

  tres2.add(DailyEquipAvail("Shovel", shovelEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Loader", loaderEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Drill", drillEquipAvail, Colors.pinkAccent));
  tres2.add(DailyEquipAvail("Truck", truckEquipAvail, Colors.pinkAccent));

  tres3.add(DailyEquipUtil("Shovel", shovelEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Loader", loaderEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Drill", drillEquipUtil, Colors.purpleAccent));
  tres3.add(DailyEquipUtil("Truck", truckEquipUtil, Colors.purpleAccent));

  nightRes1 = tres1;
  nightRes2 = tres2;
  nightRes3 = tres3;
}

//get graph details for range days
getGraphValues2(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates) {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" && i.date == dates) {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" && i.date == dates) {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" && i.date == dates) {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Drill", drillEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Truck", truckEngAvail / (3 * date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (3 * date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (3 * date.length), Colors.purpleAccent));

  resRange1 = tres1;
  resRange2 = tres2;
  resRange3 = tres3;
}

getDayGraphValues2(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates && i.shift == "Day") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Day") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Day") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Day") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  dayResRange1 = tres1;
  dayResRange2 = tres2;
  dayResRange3 = tres3;
}

getAfternoonGraphValues2(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  afternoonResRange1 = tres1;
  afternoonResRange2 = tres2;
  afternoonResRange3 = tres3;
}

getNightGraphValues2(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates && i.shift == "Night") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Night") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Night") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Night") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  nightResRange1 = tres1;
  nightResRange2 = tres2;
  nightResRange3 = tres3;
}

//get graph details for month
getGraphValues3(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates) {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" && i.date == dates) {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" && i.date == dates) {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" && i.date == dates) {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Drill", drillEngAvail / (3 * date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Truck", truckEngAvail / (3 * date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (3 * date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (3 * date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (3 * date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (3 * date.length), Colors.purpleAccent));

  resMonth1 = tres1;
  resMonth2 = tres2;
  resMonth3 = tres3;
}

getDayGraphValues3(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates && i.shift == "Day") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Day") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Day") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Day") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  dayResMonth1 = tres1;
  dayResMonth2 = tres2;
  dayResMonth3 = tres3;
}

getAfternoonGraphValues3(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Afternoon") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  afternoonResMonth1 = tres1;
  afternoonResMonth2 = tres2;
  afternoonResMonth3 = tres3;
}

getNightGraphValues3(List<EquipmentUpdate> list, List<String> date) {
  List<DailyEngAvail> tres1 = [];
  List<DailyEquipAvail> tres2 = [];
  List<DailyEquipUtil> tres3 = [];

  double shovelEquipAvail = 0;
  double shovelEngAvail = 0;
  double shovelEquipUtil = 0;

  double loaderEquipAvail = 0;
  double loaderEngAvail = 0;
  double loaderEquipUtil = 0;

  double drillEquipAvail = 0;
  double drillEngAvail = 0;
  double drillEquipUtil = 0;

  double truckEquipAvail = 0;
  double truckEngAvail = 0;
  double truckEquipUtil = 0;

  for (var dates in date) {
    for (var i in list) {
      if (i.equipment == "Shovel" && i.date == dates && i.shift == "Night") {
        shovelEquipAvail += i.equipmentAvailability;
        shovelEngAvail += i.engineeringAvailability;
        shovelEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Loader" &&
          i.date == dates &&
          i.shift == "Night") {
        loaderEquipAvail += i.equipmentAvailability;
        loaderEngAvail += i.engineeringAvailability;
        loaderEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Drill" &&
          i.date == dates &&
          i.shift == "Night") {
        drillEquipAvail += i.equipmentAvailability;
        drillEngAvail += i.engineeringAvailability;
        drillEquipUtil += i.equipmentUtilization;
      } else if (i.equipment == "Truck" &&
          i.date == dates &&
          i.shift == "Night") {
        truckEquipAvail += i.equipmentAvailability;
        truckEngAvail += i.engineeringAvailability;
        truckEquipUtil += i.equipmentUtilization;
      }
    }
  }

  tres1.add(DailyEngAvail(
      "Shovel", shovelEngAvail / (date.length), Colors.blueAccent));
  tres1.add(DailyEngAvail(
      "Loader", loaderEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Drill", drillEngAvail / (date.length), Colors.blueAccent));
  tres1.add(
      DailyEngAvail("Truck", truckEngAvail / (date.length), Colors.blueAccent));

  tres2.add(DailyEquipAvail(
      "Shovel", shovelEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Loader", loaderEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Drill", drillEquipAvail / (date.length), Colors.pinkAccent));
  tres2.add(DailyEquipAvail(
      "Truck", truckEquipAvail / (date.length), Colors.pinkAccent));

  tres3.add(DailyEquipUtil(
      "Shovel", shovelEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Loader", loaderEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Drill", drillEquipUtil / (date.length), Colors.purpleAccent));
  tres3.add(DailyEquipUtil(
      "Truck", truckEquipUtil / (date.length), Colors.purpleAccent));

  nightResMonth1 = tres1;
  nightResMonth2 = tres2;
  nightResMonth3 = tres3;
}

class DailyEngAvail {
  final String equipment;
  final double value;
  final Color color;

  DailyEngAvail(this.equipment, this.value, this.color);
}

class DailyEquipAvail {
  final String equipment;
  final double value;
  final Color color;

  DailyEquipAvail(this.equipment, this.value, this.color);
}

class DailyEquipUtil {
  final String equipment;
  final double value;
  final Color color;

  DailyEquipUtil(this.equipment, this.value, this.color);
}

class DailyEquipTarget {
  final String equipment;
  final double value;

  DailyEquipTarget(this.equipment, this.value);
}
