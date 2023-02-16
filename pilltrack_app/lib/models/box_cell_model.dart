import 'dart:ui';
import 'package:flutter/material.dart';

class Cell_info {
  final String id;
  final String dosetime;
  bool is_filled;
  bool open_next;
  String imageURL;

  Cell_info({
    required this.id,
    required this.dosetime,
    required this.is_filled,
    required this.open_next,
    required this.imageURL
});


}