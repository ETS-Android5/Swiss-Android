import 'package:flutter/material.dart';

// class Dish {
//   final String name;
//   final IconData icon;
//   final Color color;

//   Dish({this.name, this.icon, this.color});
// }

class Dish {
  final String id;
  final String product_name;
  final IconData icon;
  final String product_image;
  final String price;
  final String created_at;
  final String updated_at;
  final Color color;

  Dish(
      {this.id,
      this.product_name,
      this.icon = Icons.fastfood,
      this.product_image,
      this.price,
      this.created_at,
      this.updated_at,
      this.color});
}
