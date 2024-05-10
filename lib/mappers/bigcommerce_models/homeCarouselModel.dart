// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(
    json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerModel {
  int id;
  String name;
  String content;
  String page;
  String itemId;
  String location;
  String dateCreated;
  String dateType;
  String dateFrom;
  String dateTo;
  String visible;

  BannerModel({
    required this.id,
    required this.name,
    required this.content,
    required this.page,
    required this.itemId,
    required this.location,
    required this.dateCreated,
    required this.dateType,
    required this.dateFrom,
    required this.dateTo,
    required this.visible,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        name: json["name"],
        content: json["content"],
        page: json["page"],
        itemId: json["item_id"],
        location: json["location"],
        dateCreated: json["date_created"],
        dateType: json["date_type"],
        dateFrom: json["date_from"],
        dateTo: json["date_to"],
        visible: json["visible"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "content": content,
        "page": page,
        "item_id": itemId,
        "location": location,
        "date_created": dateCreated,
        "date_type": dateType,
        "date_from": dateFrom,
        "date_to": dateTo,
        "visible": visible,
      };
}
