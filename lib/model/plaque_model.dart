// To parse this JSON data, do
//
//     final plaqueModel = plaqueModelFromJson(jsonString);

import 'dart:convert';

List<PlaqueModel> plaqueModelFromJson(String str) => List<PlaqueModel>.from(
    json.decode(str).map((x) => PlaqueModel.fromJson(x)));

String plaqueModelToJson(List<PlaqueModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaqueModel {
  String plaqueId;
  String plaqueFullname;
  String gender;
  String dob;
  String dod;
  String jdate;
  String predate;
  String led;
  String hebruname;
  bool currentyear;
  List<Relative> relatives;

  PlaqueModel({
    required this.plaqueId,
    required this.plaqueFullname,
    required this.gender,
    required this.dob,
    required this.dod,
    required this.jdate,
    required this.predate,
    required this.led,
    required this.hebruname,
    required this.relatives,
    required this.currentyear,
  });

  factory PlaqueModel.fromJson(Map<String, dynamic> json) => PlaqueModel(
        plaqueId: json["plaque_id"],
        plaqueFullname: json["plaque_fullname"],
        gender: json["gender"],
        dob: json["dob"],
        dod: json["dod"],
        jdate: json["jdate"],
        predate: json["predate"],
        led: json["led"],
        hebruname: json["hebruname"],
        currentyear: json['currentyear'] == "1" ? true : false,
        relatives: List<Relative>.from(
            json["relatives"].map((x) => Relative.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plaque_id": plaqueId,
        "plaque_fullname": plaqueFullname,
        "gender": gender,
        "dob": dob,
        "dod": dod,
        "jdate": jdate,
        "predate": predate,
        "led": led,
        "hebruname": hebruname,
        "currentyear": currentyear,
        "relatives": List<dynamic>.from(relatives.map((x) => x.toJson())),
      };
}

class Relative {
  String id;
  String relativeFullname;
  String relativeid;
  String email;
  String number;
  String? isSms;

  Relative({
    required this.id,
    required this.relativeFullname,
    required this.relativeid,
    required this.email,
    required this.number,
    required this.isSms,
  });

  factory Relative.fromJson(Map<String, dynamic> json) => Relative(
        id: json["_id"],
        relativeFullname: json["relative_fullname"],
        relativeid: json["relativeid"],
        email: json["email"],
        number: json["number"],
        isSms: json["isSms"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "relative_fullname": relativeFullname,
        "relativeid": relativeid,
        "email": email,
        "number": number,
        "isSms": isSms,
      };
}
