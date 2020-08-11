import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_app/models/production_update.dart';
import 'package:new_app/services/auth.dart';
import 'package:new_app/utils/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//list for graph for given filters
List<DailyPro> dailyList;
List<DailyPro> rangeList;
List<DailyPro> monthList;

List<DailyProTarget> dailyTList;
List<DailyProTarget> rangeTList;
List<DailyProTarget> monthTList;

List<DailyProTarget> dayDayShiftTarget;
List<DailyProTarget> rangeDayShiftTarget;
List<DailyProTarget> monthDayShiftTarget;

List<DailyProTarget> dayAfternoonShiftTarget;
List<DailyProTarget> rangeAfternoonShiftTarget;
List<DailyProTarget> monthAfternoonShiftTarget;

List<DailyProTarget> dayNightShiftTarget;
List<DailyProTarget> rangeNightShiftTarget;
List<DailyProTarget> monthNightShiftTarget;

//graph data for shifts
List<DailyPro> dayDShiftList;
List<DailyPro> afternoonDShiftList;
List<DailyPro> nightDShiftList;

List<DailyPro> dayRShiftList;
List<DailyPro> afternoonRShiftList;
List<DailyPro> nightRShiftList;

List<DailyPro> dayMShiftList;
List<DailyPro> afternoonMShiftList;
List<DailyPro> nightMShiftList;

//list for all filters
List<ProductionUpdate> dayList;
List<ProductionUpdate> rangeFList;
List<ProductionUpdate> monthlyList;

//lists based on shifts for day
List<ProductionUpdate> dayDayShiftList;
List<ProductionUpdate> dayAfternoonShiftList;
List<ProductionUpdate> dayNightShiftList;

//lists based on shifts for month
List<ProductionUpdate> monthDayShiftList;
List<ProductionUpdate> monthAfternoonShiftList;
List<ProductionUpdate> monthNightShiftList;

//lists based on shifts for range
List<ProductionUpdate> rangeDayShiftList;
List<ProductionUpdate> rangeAfternoonShiftList;
List<ProductionUpdate> rangeNightShiftList;

final now = new DateTime.now();
String formatter = DateFormat('dd-MM-yyyy').format(now);
bool res;
// add commas to numbers for card views
RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

final BaseAuth auth = new Auth();

List<DailyProTarget> chartData2 = [
  DailyProTarget('HeadFeed', 7000),
  DailyProTarget('OreExpits', 9000),
  DailyProTarget('Waste', 5000),
  // DailyProTarget('Drilled', 26000)
];
List<DailyProTarget> chart1 = [
  DailyProTarget('HeadFeed', 21000),
  DailyProTarget('OreExpits', 27000),
  DailyProTarget('Waste', 15000),
  // DailyProTarget('Drilled', 75000)
];
List<DailyProTarget> chart2;
List<DailyProTarget> chart3;

//calculate sum of headfeed for given data
getHeadFeedMthSum(List<ProductionUpdate> monthlyList) {
  int sum = 0;
  for (var i in monthlyList) {
    if (i.product == "HeadFeed") {
      sum += i.value.toInt();
    }
  }
  return sum;
}

//calculate sum of waste for given data
getWasteMthSum(List<ProductionUpdate> monthlyList) {
  int sum = 0;
  for (var i in monthlyList) {
    if (i.product == "Waste") {
      sum += i.value.toInt();
    }
  }
  return sum;
}

//calculate sum of drilled for given data
getDrilledMthSum(List<ProductionUpdate> monthlyList) {
  int sum = 0;
  for (var i in monthlyList) {
    if (i.product == "Drilled") {
      sum += i.value.toInt();
    }
  }
  return sum;
}

//calculate sum of ore expits for given data
getOreExpitsMthSum(List<ProductionUpdate> monthlyList) {
  int sum = 0;
  for (var i in monthlyList) {
    if (i.product == "OreExpits") {
      sum += i.value.toInt();
    }
  }
  return sum;
}

//get daily data as list
getDailyProductions(String name) async {
  List<ProductionUpdate> productList;
  productList = await DatabaseHelper.db.getDailyProductionUpdate(name);
  return productList;
}

//get days between provided dates as list
List<String> getDaysInBeteween(DateTime startDate, DateTime endDate) {
  List<String> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(DateFormat('dd-MM-yyyy').format(startDate.add(Duration(days: i))));
  }
  return days;
}

//get data to be displayed on graph based on filter selected, for daily
getGraphValues(List<ProductionUpdate> list, String date) {
  List<DailyPro> res = [];
  double headFeedSum = 0;
  double oreExpitSum = 0;
  double wasteSum = 0;
  // double drilledSum = 0;

  for (var i in list) {
    if (i.product == "HeadFeed" && i.date == date) {
      headFeedSum += i.value;
    } else if (i.product == "OreExpits" && i.date == date) {
      oreExpitSum += i.value;
    } else if (i.product == "Waste" && i.date == date) {
      wasteSum += i.value;
    }
    // else if (i.product == "Drilled" && i.date == date) {
    //   drilledSum += i.value;
    // }
  }

  res.add(DailyPro("HeadFeed", headFeedSum, Colors.blueAccent));
  res.add(DailyPro("OreExpits", oreExpitSum, Colors.pinkAccent));
  res.add(DailyPro("Waste", wasteSum, Colors.redAccent));
  // res.add(DailyPro("Drilled", drilledSum, Colors.purpleAccent));

  return res;
}

//get data to be displayed on graph based on filter selected, for given date range
getGraphValues2(List<ProductionUpdate> list) {
  List<DailyPro> res = [];
  double headFeedSum = 0;
  double oreExpitSum = 0;
  double wasteSum = 0;
  // double drilledSum = 0;

  for (var i in list) {
    if (i.product == "HeadFeed") {
      headFeedSum += i.value;
    } else if (i.product == "OreExpits") {
      oreExpitSum += i.value;
    } else if (i.product == "Waste") {
      wasteSum += i.value;
    }
    // else if (i.product == "Drilled") {
    //   drilledSum += i.value;
    // }
  }

  res.add(DailyPro("HeadFeed", headFeedSum, Colors.blueAccent));
  res.add(DailyPro("OreExpits", oreExpitSum, Colors.pinkAccent));
  res.add(DailyPro("Waste", wasteSum, Colors.redAccent));
  // res.add(DailyPro("Drilled", drilledSum, Colors.purpleAccent));

  return res;
}

//graph model class for graph production data
class DailyPro {
  final String product;
  final double value;
  final Color color;

  DailyPro(this.product, this.value, this.color);
}

//graph model class for graph target data
class DailyProTarget {
  final String target;
  final double value;

  DailyProTarget(this.target, this.value);
}

//get daily data from db for graph
Future<ProductionUpdate> getProductionData(DateTime date) async {
  await DatabaseHelper.db
      .getDailyProductionUpdate(DateFormat('dd-MM-yyyy').format(date))
      .then((value) {
    dailyList = getGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

Future<ProductionUpdate> getDayProductionData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftProductionUpdate(DateFormat('dd-MM-yyyy').format(date), "Day")
      .then((value) {
    dayDShiftList =
        getGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

Future<ProductionUpdate> getAfternoonProductionData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftProductionUpdate(
          DateFormat('dd-MM-yyyy').format(date), "Afternoon")
      .then((value) {
    afternoonDShiftList =
        getGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

Future<ProductionUpdate> getNightProductionData(DateTime date) async {
  await DatabaseHelper.db
      .getShiftProductionUpdate(DateFormat('dd-MM-yyyy').format(date), "Night")
      .then((value) {
    nightDShiftList =
        getGraphValues(value, DateFormat('dd-MM-yyyy').format(date));
  });
}

//get the data from db for given range for graph
Future<ProductionUpdate> getRangeData(DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyProductionUpdate(getDaysInBeteween(date, date2))
      .then((value) {
    rangeList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getDayRangeData(DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Day")
      .then((value) {
    dayRShiftList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getAfternoonRangeData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(
          getDaysInBeteween(date, date2), "Afternoon")
      .then((value) {
    afternoonRShiftList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getNightRangeData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Night")
      .then((value) {
    nightRShiftList = getGraphValues2(value);
  });
}

//get the data from db for any given month for graph
Future<ProductionUpdate> getMonthData(DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyProductionUpdate(getDaysInBeteween(date, date2))
      .then((value) {
    monthList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getDayMonthData(DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Day")
      .then((value) {
    dayMShiftList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getAfternoonMonthData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(
          getDaysInBeteween(date, date2), "Afternoon")
      .then((value) {
    afternoonMShiftList = getGraphValues2(value);
  });
}

Future<ProductionUpdate> getNightMonthData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Night")
      .then((value) {
    nightMShiftList = getGraphValues2(value);
  });
}

//get daily data from db
Future<ProductionUpdate> getDailyData(DateTime date) async {
  dayList = await DatabaseHelper.db
      .getDailyProductionUpdate(DateFormat('dd-MM-yyyy').format(date));
}

Future<ProductionUpdate> getDayDailyData(DateTime date) async {
  dayDayShiftList = await DatabaseHelper.db
      .getShiftProductionUpdate(DateFormat('dd-MM-yyyy').format(date), "Day");
}

Future<ProductionUpdate> getAfternoonDailyData(DateTime date) async {
  dayAfternoonShiftList = await DatabaseHelper.db.getShiftProductionUpdate(
      DateFormat('dd-MM-yyyy').format(date), "Afternoon");
}

Future<ProductionUpdate> getNightDailyData(DateTime date) async {
  dayNightShiftList = await DatabaseHelper.db
      .getShiftProductionUpdate(DateFormat('dd-MM-yyyy').format(date), "Night");
}

//get the data from db for given range
Future<ProductionUpdate> getRangeListData(DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyProductionUpdate(getDaysInBeteween(date, date2))
      .then((value) {
    rangeFList = value;
    rangeTList = getTarget("Range", value);
  });
}

Future<ProductionUpdate> getDayRangeListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Day")
      .then((value) {
    rangeDayShiftList = value;
    rangeDayShiftTarget = getTarget2("Range", value, shift: "Day");
  });
}

Future<ProductionUpdate> getAfternoonRangeListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(
          getDaysInBeteween(date, date2), "Afternoon")
      .then((value) {
    rangeAfternoonShiftList = value;
    rangeAfternoonShiftTarget = getTarget2("Range", value, shift: "Afternoon");
  });
}

Future<ProductionUpdate> getNightRangeListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Night")
      .then((value) {
    rangeNightShiftList = value;
    rangeNightShiftTarget = getTarget2("Range", value, shift: "Night");
  });
}

//get the data from db for any given month
Future<ProductionUpdate> getMonthlyListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getMonthlyProductionUpdate(getDaysInBeteween(date, date2))
      .then((value) {
    monthlyList = value;
    monthTList = getTarget("Monthly", value);
  });
}

Future<ProductionUpdate> getDayMonthlyListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Day")
      .then((value) {
    monthDayShiftList = value;
    monthDayShiftTarget = getTarget2("Monthly", value, shift: "Day");
  });
}

Future<ProductionUpdate> getAfternoonMonthlyListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(
          getDaysInBeteween(date, date2), "Afternoon")
      .then((value) {
    monthAfternoonShiftList = value;
    monthAfternoonShiftTarget =
        getTarget2("Monthly", value, shift: "Afternoon");
  });
}

Future<ProductionUpdate> getNightMonthlyListData(
    DateTime date, DateTime date2) async {
  await DatabaseHelper.db
      .getShiftRangeProductionUpdate(getDaysInBeteween(date, date2), "Night")
      .then((value) {
    monthNightShiftList = value;
    monthNightShiftTarget = getTarget2("Monthly", value, shift: "Night");
  });
}

//get the method to calculate sum for given name
String getMethod(String name, List<ProductionUpdate> monthlyList) {
  if (name == "HeadFeed") {
    return getHeadFeedMthSum(monthlyList)
        .toString()
        .replaceAllMapped(reg, mathFunc);
  } else if (name == "OreExpits") {
    return getOreExpitsMthSum(monthlyList)
        .toString()
        .replaceAllMapped(reg, mathFunc);
  } else if (name == "Waste") {
    return getWasteMthSum(monthlyList)
        .toString()
        .replaceAllMapped(reg, mathFunc);
  } else
    return getDrilledMthSum(monthlyList)
        .toString()
        .replaceAllMapped(reg, mathFunc);
}

//get the last date for given month
getLastDateOfMonth(DateTime date) {
  var now = date;
  var beginningNextMonth = (now.month < 12)
      ? new DateTime(now.year, now.month + 1, 1)
      : new DateTime(now.year + 1, 1, 1);
  var lastDay = beginningNextMonth.subtract(new Duration(days: 1)).day;

  var lastDate = new DateTime(now.year, now.month, lastDay);
  var parsedDate =
      DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(lastDate));
  return parsedDate;
}

//get first date for a given month
getFirstDateOfMonth(DateTime date) {
  var now = date;
  var firstDate = new DateTime(now.year, now.month, 1);
  var parsedDate = DateFormat('dd-MM-yyyy')
      .parse(DateFormat('dd-MM-yyyy').format(firstDate));
  return parsedDate;
}

//get the number of days in range
getNoOfDaysRange(List<ProductionUpdate> list) {
  double sum = 0;
  for (var i in list) {
    if (i.product == "HeadFeed" && i.shift == "Night") {
      sum++;
    }
  }
  return sum;
}

getNoOfShiftDaysRange(List<ProductionUpdate> list, String shift) {
  double sum = 0;
  for (var i in list) {
    if (i.product == "HeadFeed" && i.shift == shift) {
      sum++;
    }
  }
  return sum;
}

//get the number of days in month
getNoOfDaysMonth(List<ProductionUpdate> list) {
  double sum = 0;
  for (var i in list) {
    if (i.product == "HeadFeed" && i.shift == "Night") {
      sum++;
    }
  }
  return sum;
}

//get target for every filter
List<DailyProTarget> getTarget(String filter, List<ProductionUpdate> list) {
  if (filter == "Day") {
    List<DailyProTarget> chartData = [];
    chartData.add(DailyProTarget('HeadFeed', 21000));
    chartData.add(DailyProTarget('OreExpits', 27000));
    chartData.add(DailyProTarget('Waste', 15000));
    // chartData.add(DailyProTarget('Drilled', 75000));

    return chartData;
  } else if (filter == "Range") {
    List<DailyProTarget> chartData = [
      DailyProTarget('HeadFeed', 21000 * getNoOfDaysRange(list)),
      DailyProTarget('OreExpits', 27000 * getNoOfDaysRange(list)),
      DailyProTarget('Waste', 15000 * getNoOfDaysRange(list)),
      // DailyProTarget('Drilled', 75000 * getNoOfDaysRange(rangeFList))
    ];
    return chartData;
  } else if (filter == "Monthly") {
    List<DailyProTarget> chartData = [
      DailyProTarget('HeadFeed', 21000 * getNoOfDaysMonth(list)),
      DailyProTarget('OreExpits', 27000 * getNoOfDaysMonth(list)),
      DailyProTarget('Waste', 15000 * getNoOfDaysMonth(list)),
      // DailyProTarget('Drilled', 75000 * getNoOfDaysMonth(monthlyList))
    ];
    return chartData;
  }
}

List<DailyProTarget> getTarget2(String filter, List<ProductionUpdate> list,
    {String shift}) {
  if (filter == "Day") {
    List<DailyProTarget> chartData = [];
    chartData.add(DailyProTarget('HeadFeed', 7000));
    chartData.add(DailyProTarget('OreExpits', 9000));
    chartData.add(DailyProTarget('Waste', 5000));
    // chartData.add(DailyProTarget('Drilled', 75000));

    return chartData;
  } else if (filter == "Range") {
    List<DailyProTarget> chartData = [
      DailyProTarget('HeadFeed', 7000 * getNoOfShiftDaysRange(list, shift)),
      DailyProTarget('OreExpits', 9000 * getNoOfShiftDaysRange(list, shift)),
      DailyProTarget('Waste', 5000 * getNoOfShiftDaysRange(list, shift)),
      // DailyProTarget('Drilled', 75000 * getNoOfDaysRange(rangeFList))
    ];
    return chartData;
  } else if (filter == "Monthly") {
    List<DailyProTarget> chartData = [
      DailyProTarget('HeadFeed', 7000 * getNoOfShiftDaysRange(list, shift)),
      DailyProTarget('OreExpits', 9000 * getNoOfShiftDaysRange(list, shift)),
      DailyProTarget('Waste', 5000 * getNoOfShiftDaysRange(list, shift)),
      // DailyProTarget('Drilled', 75000 * getNoOfDaysMonth(monthlyList))
    ];
    return chartData;
  }
}
