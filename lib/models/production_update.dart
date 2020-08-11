import 'dart:convert';

List<ProductionUpdate> productionFromJson(String str) =>
    List<ProductionUpdate>.from(
        json.decode(str).map((x) => ProductionUpdate.fromJson(x)));

String productionToJson(List<ProductionUpdate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductionUpdate {
  int id;
  String product;
  double value;
  String comments;
  String date;
  String shift;

  ProductionUpdate(
      {this.id,
      this.value,
      this.product,
      this.comments,
      this.date,
      this.shift});

  factory ProductionUpdate.fromJson(Map<String, dynamic> json) =>
      ProductionUpdate(
        id: json["id"],
        product: json["product"],
        value: (json["value"] as num).toDouble(),
        comments: json["comments"],
        date: json["date"],
        shift: json["shift"],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'value': value,
      'date': date,
      'comments': comments,
      'shift': shift,
    };
  }
}
