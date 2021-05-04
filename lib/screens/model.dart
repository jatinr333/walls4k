// To parse this JSON data, do
//
//     final walls = wallsFromJson(jsonString);

import 'dart:convert';

List<Walls> wallsFromJson(String str) =>
    List<Walls>.from(json.decode(str).map((x) => Walls.fromJson(x)));

String wallsToJson(List<Walls> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Walls {
  Walls({
    this.imgSrc,
    this.imgThumb,
  });

  String imgSrc;
  String imgThumb;

  factory Walls.fromJson(Map<String, dynamic> json) => Walls(
        imgSrc: json["img-src"],
        imgThumb: json["img-thumb"],
      );

  Map<String, dynamic> toJson() => {
        "img-src": imgSrc,
        "img-thumb": imgThumb,
      };
}
