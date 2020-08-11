import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:new_app/models/equipment_update.dart';
import 'package:new_app/models/production_update.dart';
import 'package:new_app/services/auth.dart';
import 'package:new_app/utils/commons1.dart';
import 'package:new_app/utils/commons2.dart';
import 'package:new_app/widgets/dashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AfternoonShift extends StatefulWidget {
  final BaseAuth auth;
  AfternoonShift({this.auth});
  @override
  _AfternoonShiftState createState() => _AfternoonShiftState();
}

class _AfternoonShiftState extends State<AfternoonShift> {
  DateTime selectedDate = DateTime.now();
  List<String> nameList = ["HeadFeed", "OreExpits", "Waste", "Drilled"];
  List<String> nameList2 = ["Loader", "Truck", "Shovel", "Drill"];
  final List<Color> colors = <Color>[
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.redAccent,
    Colors.purpleAccent
  ];
  DateTime monthlyDate = DateTime.now();
  List<DateTime> dateRange = [
    DateTime.now(),
    DateTime.now().add(new Duration(days: 7))
  ];
  bool isLoading;
  bool getData;
  bool isComments;
  bool isComments2;
  String dayFilter;

  @override
  void initState() {
    super.initState();
    dayFilter = "Day";
    isLoading = true;
    getData = true;
    isComments = true;
    isComments2 = true;
    getAfternoonMonthData(
        getFirstDateOfMonth(monthlyDate), getLastDateOfMonth(monthlyDate));
    getAfternoonRangeData(dateRange[0], dateRange[dateRange.length - 1]);
    getAfternoonRangeListData(dateRange[0], dateRange[dateRange.length - 1]);
    getAfternoonMonthlyListData(
        getFirstDateOfMonth(monthlyDate), getLastDateOfMonth(monthlyDate));
    getAfternoonProductionData(selectedDate);
    getAfternoonRangeEquipmentData(
        dateRange[0], dateRange[dateRange.length - 1]);
    getAfternoonMonthEquipmentData(
        getFirstDateOfMonth(monthlyDate), getLastDateOfMonth(monthlyDate));
    getAfternoonEquipmentData(selectedDate);
    getAfternoonDailyData(selectedDate).then((value) {
      setState(() {
        isLoading = false;
        isComments = false;
        getData = false;
        isComments2 = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Afternoon Shift",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Text(
                    getDateFormat(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 25.0,
                  )
                ],
              ),
              onPressed: () => _selectDate(context, dayFilter),
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              getTab(index);
            },
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Day",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                  child: Text(
                "Range",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )),
              Tab(
                  child: Text(
                "Monthly",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )),
            ],
          ),
        ),
        body: getData
            ? Center(
                child: Text("Loading..."),
              )
            : getFilterData(),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String filter) async {
    if (filter == "Day") {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        isLoading = true;
        getData = true;
        isComments = true;
        isComments2 = true;
        await getAfternoonDailyData(picked);
        await getAfternoonProductionData(picked);
        await getAfternoonEquipmentData(picked).then((value) {
          setState(() {
            selectedDate = picked;
            isLoading = false;
            getData = false;
            isComments = false;
            isComments2 = false;
          });
        });
      }
    } else if (filter == "Range") {
      final List<DateTime> picked = await DateRagePicker.showDatePicker(
          context: context,
          initialFirstDate: dateRange[0],
          initialLastDate: dateRange[dateRange.length - 1],
          firstDate: new DateTime(2015),
          lastDate: new DateTime(2101));
      if (picked != null && picked.length == 2) {
        isLoading = true;
        getData = true;
        isComments = true;
        isComments2 = true;
        await getAfternoonRangeData(picked[0], picked[picked.length - 1]);
        await getAfternoonRangeListData(picked[0], picked[picked.length - 1]);
        await getAfternoonRangeEquipmentData(
                picked[0], picked[picked.length - 1])
            .then((value) {
          setState(() {
            dateRange = picked;
            isLoading = false;
            getData = false;
            isComments = false;
            isComments2 = false;
          });
        });
      }
    } else if (filter == "Monthly") {
      final DateTime picked = await showMonthPicker(
        context: context,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101),
        initialDate: monthlyDate,
      );
      if (picked != null && picked != monthlyDate) {
        isLoading = true;
        getData = true;
        isComments = true;
        isComments2 = true;
        await getAfternoonMonthData(
            getFirstDateOfMonth(picked), getLastDateOfMonth(picked));
        await getAfternoonMonthlyListData(
            getFirstDateOfMonth(picked), getLastDateOfMonth(picked));
        await getAfternoonMonthEquipmentData(
                getFirstDateOfMonth(picked), getLastDateOfMonth(picked))
            .then((value) {
          setState(() {
            monthlyDate = picked;
            isLoading = false;
            getData = false;
            isComments = false;
            isComments2 = false;
          });
        });
      }
    }
  }

  getTab(int index) {
    if (index == 0) {
      setState(() {
        dayFilter = "Day";
      });
    } else if (index == 1) {
      setState(() {
        dayFilter = "Range";
      });
    } else if (index == 2) {
      setState(() {
        dayFilter = "Monthly";
      });
    }
  }

  Widget getFilterData() {
    if (dayFilter == "Range") {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Production Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    height: 100,
                    child: FutureBuilder<ProductionUpdate>(
                        future: getAfternoonRangeListData(
                            dateRange[0], dateRange[dateRange.length - 1]),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: nameList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTapCancel: () {},
                                  child: Container(
                                    width: 120.0,
                                    child: Card(
                                      color: colors[index],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              nameList[index],
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Total:",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            isLoading == true
                                                ? Text("Loading...")
                                                : getValues(nameList[index],
                                                    rangeAfternoonShiftList),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 275.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'point.x: point.yt',
                          ),
                          title: ChartTitle(
                              text: 'Range Production Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyPro, String>(
                              isVisibleInLegend: false,
                              name: "Product",
                              dataSource: afternoonRShiftList,
                              xValueMapper: (DailyPro data, _) => data.product,
                              yValueMapper: (DailyPro data, _) => data.value,
                              width: 0.6,
                              // Map color for each data points from the data source
                              pointColorMapper: (DailyPro data, _) =>
                                  data.color,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyProTarget, String>(
                              name: "Target",
                              dataSource: rangeAfternoonShiftTarget,
                              xValueMapper: (DailyProTarget data, _) =>
                                  data.target,
                              yValueMapper: (DailyProTarget data, _) =>
                                  data.value,
                              width: 0.6,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            )
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments(rangeAfternoonShiftList),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Equipment Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 300.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: "Equipment",
                            format: 'point.x: point.y%',
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            rangePadding: ChartRangePadding.none,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          title: ChartTitle(
                              text: 'Range Equipment Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyEngAvail, String>(
                              dataSource: afternoonResRange1,
                              name: "ENA",
                              xValueMapper: (DailyEngAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEngAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.blueAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipAvail, String>(
                              dataSource: afternoonResRange2,
                              name: "EQA",
                              xValueMapper: (DailyEquipAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.purpleAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipUtil, String>(
                              dataSource: afternoonResRange3,
                              name: "EQU",
                              xValueMapper: (DailyEquipUtil data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipUtil data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.pinkAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipTarget, String>(
                              dataSource: equipChartData,
                              name: "Target",
                              xValueMapper: (DailyEquipTarget data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipTarget data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            ),
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments2(rangeAfternoonShiftEList),
              ),
            ],
          )
        ],
      );
    } else if (dayFilter == "Monthly") {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Production Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    height: 100,
                    child: FutureBuilder<ProductionUpdate>(
                        future: getAfternoonMonthlyListData(
                            getFirstDateOfMonth(monthlyDate),
                            getLastDateOfMonth(monthlyDate)),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: nameList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTapCancel: () {},
                                  child: Container(
                                    width: 120.0,
                                    child: Card(
                                      color: colors[index],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              nameList[index],
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Total:",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            isLoading == true
                                                ? Text("Loading...")
                                                : getValues(nameList[index],
                                                    monthAfternoonShiftList),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 275.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'point.x: point.yt',
                          ),
                          title: ChartTitle(
                              text: 'Monthly Production Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyPro, String>(
                              isVisibleInLegend: false,
                              name: "Product",
                              dataSource: afternoonMShiftList,
                              xValueMapper: (DailyPro data, _) => data.product,
                              yValueMapper: (DailyPro data, _) => data.value,
                              width: 0.6,
                              // Map color for each data points from the data source
                              pointColorMapper: (DailyPro data, _) =>
                                  data.color,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyProTarget, String>(
                              name: "Target",
                              dataSource: monthAfternoonShiftTarget,
                              xValueMapper: (DailyProTarget data, _) =>
                                  data.target,
                              yValueMapper: (DailyProTarget data, _) =>
                                  data.value,
                              width: 0.6,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            )
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments(monthAfternoonShiftList),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Equipment Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 300.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: "Equipment",
                            format: 'point.x: point.y%',
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            rangePadding: ChartRangePadding.none,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          title: ChartTitle(
                              text: 'Monthly Equipment Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyEngAvail, String>(
                              dataSource: afternoonResMonth1,
                              name: "ENA",
                              xValueMapper: (DailyEngAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEngAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.blueAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipAvail, String>(
                              dataSource: afternoonResMonth2,
                              name: "EQA",
                              xValueMapper: (DailyEquipAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.purpleAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipUtil, String>(
                              dataSource: afternoonResMonth3,
                              name: "EQU",
                              xValueMapper: (DailyEquipUtil data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipUtil data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.pinkAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipTarget, String>(
                              dataSource: equipChartData,
                              name: "Target",
                              xValueMapper: (DailyEquipTarget data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipTarget data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            ),
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments2(monthAfternoonShiftEList),
              ),
            ],
          )
        ],
      );
    } else
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Production Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                    height: 100,
                    child: FutureBuilder<ProductionUpdate>(
                        future: getAfternoonDailyData(selectedDate),
                        builder: (context, snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: nameList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTapCancel: () {},
                                  child: Container(
                                    width: 120.0,
                                    child: Card(
                                      color: colors[index],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              nameList[index],
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Total:",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1.5,
                                                color: Colors.white,
                                              ),
                                            ),
                                            isLoading == true
                                                ? Text("Loading...")
                                                : getValues(nameList[index],
                                                    dayAfternoonShiftList),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 275.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            format: 'point.x: point.yt',
                          ),
                          title: ChartTitle(
                              text: 'Daily Production Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyPro, String>(
                              isVisibleInLegend: false,
                              name: "Product",
                              dataSource: afternoonDShiftList,
                              xValueMapper: (DailyPro data, _) => data.product,
                              yValueMapper: (DailyPro data, _) => data.value,
                              width: 0.6,
                              // Map color for each data points from the data source
                              pointColorMapper: (DailyPro data, _) =>
                                  data.color,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyProTarget, String>(
                              name: "Target",
                              dataSource:
                                  getTarget2(dayFilter, dayAfternoonShiftList),
                              xValueMapper: (DailyProTarget data, _) =>
                                  data.target,
                              yValueMapper: (DailyProTarget data, _) =>
                                  data.value,
                              width: 0.6,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            )
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments(dayAfternoonShiftList),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Equipment Updates",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                      height: 300.0,
                      child: SfCartesianChart(
                          borderColor: Colors.black,
                          borderWidth: 2,
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: "Equipment",
                            format: 'point.x: point.y%',
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            rangePadding: ChartRangePadding.none,
                          ),
                          legend: Legend(
                            isVisible: true,
                            borderColor: Colors.black,
                            borderWidth: 1.0,
                            position: LegendPosition.bottom,
                          ),
                          title: ChartTitle(
                              text: 'Daily Equipment Updates',
                              borderWidth: 2,
                              // Aligns the chart title to left
                              alignment: ChartAlignment.center,
                              textStyle: ChartTextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              )),
                          primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.betweenTicks,
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<DailyEngAvail, String>(
                              dataSource: afternoonRes1,
                              name: "ENA",
                              xValueMapper: (DailyEngAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEngAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.blueAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipAvail, String>(
                              dataSource: afternoonRes2,
                              name: "EQA",
                              xValueMapper: (DailyEquipAvail data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipAvail data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.purpleAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipUtil, String>(
                              dataSource: afternoonRes3,
                              name: "EQU",
                              xValueMapper: (DailyEquipUtil data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipUtil data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.pinkAccent,
                              enableTooltip: true,
                            ),
                            ColumnSeries<DailyEquipTarget, String>(
                              dataSource: equipChartData,
                              name: "Target",
                              xValueMapper: (DailyEquipTarget data, _) =>
                                  data.equipment,
                              yValueMapper: (DailyEquipTarget data, _) =>
                                  data.value,
                              width: 0.8,
                              color: Colors.greenAccent,
                              enableTooltip: true,
                            ),
                          ]))),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: getComments2(dayAfternoonShiftEList),
              ),
            ],
          )
        ],
      );
  }

  getDateFormat() {
    if (dayFilter == "Day") {
      return DateFormat('dd-MM-yyyy').format(selectedDate);
    } else if (dayFilter == "Range") {
      return "${DateFormat('dd-MM-yy').format(dateRange[0])} - ${DateFormat('dd-MM-yy').format(dateRange[dateRange.length - 1])}";
    } else if (dayFilter == "Monthly") {
      return DateFormat('MMMM').format(monthlyDate);
    }
  }

  Widget getComments(List<ProductionUpdate> commentsList) {
    return isComments
        ? Text("Loading")
        : ExpansionTile(
            leading: Icon(Icons.comment),
            trailing: Text(commentsList.length.toString()),
            title: Text("Comments"),
            children: <Widget>[
                Container(
                  height: 200.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: commentsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Product: ${commentsList[index].product}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "Shift: ${commentsList[index].shift}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Date: ${commentsList[index].date}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              commentsList[index].comments,
                              softWrap: true,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ]);
  }

  Widget getComments2(List<EquipmentUpdate> commentsList) {
    return isComments2
        ? Text("Loading")
        : ExpansionTile(
            leading: Icon(Icons.comment),
            trailing: Text(commentsList.length.toString()),
            title: Text("Comments"),
            children: <Widget>[
                Container(
                  height: 200.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: commentsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Date: ${commentsList[index].date}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "Shift: ${commentsList[index].shift}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              commentsList[index].comments,
                              softWrap: true,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ]);
  }
}
