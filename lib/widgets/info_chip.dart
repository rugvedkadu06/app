// lib/widgets/info_chip.dart
import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoChip({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2.0), child: Row(children: [ Icon(icon, size: 16, color: Colors.grey.shade600), const SizedBox(width: 8), Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700), maxLines: 1, overflow: TextOverflow.ellipsis))]));
  }
}


