// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pagosapp/src/utils/validators.dart';

class Client {
    int id;
    String name;
    String fb;
    String phoneA;
    String phoneB;
    String addressA;
    String cityA;
    double latA;
    double lngA;
    String addressB;
    String cityB;
    double latB;
    double lngB;
    String refA;
    String refB;
    int userId;
    int rank;
    DateTime updatedAt;
    DateTime createdAt;    
    File refOne;
    File refTwo;

    Client({
        this.id,
        this.name,
        this.fb,
        this.phoneA,
        this.phoneB,
        this.addressA,
        this.cityA,
        this.latA,
        this.lngA,
        this.addressB,
        this.cityB,
        this.latB,
        this.lngB,
        this.refA,
        this.refB,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.refOne,
        this.refTwo,
        this.rank,        
    });

    factory Client.fromJson(String str) => Client.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json["id"],
        rank: parseInt(json["rank"]),
        name: json["name"],
        fb: json["fb"],
        phoneA: json["phone_a"],
        phoneB: json["phone_b"],
        addressA: json["address_a"],
        cityA: json["city_a"],
        latA: parseDouble(json["lat_a"]),
        lngA: parseDouble(json["lng_a"]),
        addressB: json["address_b"],
        cityB: json["city_b"],
        latB: parseDouble(json["lat_b"]),
        lngB: parseDouble(json["lng_b"]),
        refA: json["ref_a"],
        refB: json["ref_b"],
        userId: json["user_id"],           
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "fb": fb,
        "phone_a": phoneA,
        "phone_b": phoneB,
        "city_a": cityA,
        "address_a": addressA,
        "lat_a": latA,
        "lng_a": lngA,
        "city_b": cityB,
        "address_b": addressB,
        "lat_b": latB,
        "lng_b": lngB,
        "ref_a": refA,
        "ref_b": refB,
        'rank': rank,
        "user_id": userId,        
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
    };

    getColor() {
      if(rank <= 100 && rank >= 90) {
        return Colors.green;
      }

      if(rank >= 50 && rank < 90 ) {
        return Colors.orange;
      }

      if(rank < 50) {
        return Colors.red;
      }
    }
}
