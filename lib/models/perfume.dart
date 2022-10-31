import 'package:flutter/material.dart';

class Perfume {
  String id;
  String name;
  String description;
  String imageUrl;
  String price;
  // DateTime date;

  Perfume(
    {
      required this.id,

      required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    // required this.date,
    }
  );
}