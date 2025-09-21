// lib/models/coupon.dart
import 'package:flutter/material.dart';

class Coupon {
  final String id;
  final String title;
  final String description;
  final int cost;
  final IconData icon;
  final Color color;
  final DateTime validTill;

  Coupon({required this.id, required this.title, required this.description, required this.cost, required this.icon, required this.color, required this.validTill});

  bool get isExpired => DateTime.now().isAfter(validTill);
}


