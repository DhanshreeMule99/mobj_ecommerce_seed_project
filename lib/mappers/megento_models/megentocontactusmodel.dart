import 'package:meta/meta.dart';
import 'dart:convert';

ContactUsModel contactUsModelFromJson(String str) =>
    ContactUsModel.fromJson(json.decode(str));

String contactUsModelToJson(ContactUsModel data) => json.encode(data.toJson());

class ContactUsModel {
  Data data;
  Meta meta;

  ContactUsModel({
    required this.data,
    required this.meta,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
        data: Data.fromJson(json["data"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "meta": meta.toJson(),
      };
}

class Data {
  int id;
  Attributes attributes;

  Data({
    required this.id,
    required this.attributes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

class Attributes {
  String mobileNumber;
  String email;
  String address;
  String instagramUrl;
  String facebookUrl;
  String twitterUrl;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String whatsAppNumber;

  Attributes({
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.whatsAppNumber,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        mobileNumber: json["mobile_number"],
        email: json["email"],
        address: json["address"],
        instagramUrl: json["instagram_url"],
        facebookUrl: json["facebook_url"],
        twitterUrl: json["twitter_url"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        whatsAppNumber: json["whats_app_number"],
      );

  Map<String, dynamic> toJson() => {
        "mobile_number": mobileNumber,
        "email": email,
        "address": address,
        "instagram_url": instagramUrl,
        "facebook_url": facebookUrl,
        "twitter_url": twitterUrl,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "whats_app_number": whatsAppNumber,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
