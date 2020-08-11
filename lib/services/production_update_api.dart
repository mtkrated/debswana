import 'package:dio/dio.dart';
import 'package:new_app/models/production_update.dart';
import 'package:new_app/utils/database_helper.dart';

class ProductionUpdateApi {
  Future<List<ProductionUpdate>> getAllProductionUpdates() async {
    var url = "http://afrovenus.com/webservice/debswana/fake_data.json";
    Response response = await Dio().get(url);

    return (response.data as List).map((production) {
      print('Inserting $production');
      DatabaseHelper.db.createProduction(ProductionUpdate.fromJson(production));
    }).toList();
  }
}
