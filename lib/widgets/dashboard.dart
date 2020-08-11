import 'package:flutter/material.dart';
import 'package:new_app/models/production_update.dart';
import 'package:new_app/utils/commons1.dart';

Widget getValues(String name, List<ProductionUpdate> monthlyList) {
  if (name == "HeadFeed") {
    return Text(
      "${getMethod(name, monthlyList)}t",
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: Colors.white,
      ),
    );
  } else if (name == "OreExpits") {
    return Text(
      "${getMethod(name, monthlyList)}t",
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: Colors.white,
      ),
    );
  } else if (name == "Waste") {
    return Text(
      "${getMethod(name, monthlyList)}t",
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: Colors.white,
      ),
    );
  } else
    return Text(
      "${getMethod(name, monthlyList)}t",
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: Colors.white,
      ),
    );
}
