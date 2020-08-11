import 'package:dio/dio.dart';
import 'package:new_app/models/equipment_update.dart';
import 'package:new_app/utils/database_helper.dart';

class EquipmentUpdateApi {
  Future<List<EquipmentUpdate>> getAllEquipmentUpdates() async {
    var url = "http://afrovenus.com/webservice/debswana/fake_data_2.json";
    Response response = await Dio().get(url);

    return (response.data as List).map((equipment) {
      print('Inserting $equipment');
      DatabaseHelper.db.createEquipment(EquipmentUpdate.fromJson(equipment));
    }).toList();
  }
}
