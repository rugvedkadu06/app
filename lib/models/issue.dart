// lib/models/issue.dart
import 'package:flutter/material.dart';
import '../api/ai_analysis_service.dart';

enum IssueStatus { pending, approved, inProgress, resolved }

class Issue {
  final String id;
  final String title;
  final String description;
  final String location;
  final IssueStatus status;
  final DateTime createdAt;
  bool pointsRedeemed;
  final String? imagePath;
  final String? imageUrl; // Cloudinary URL
  final String submittedBy;
  final String placeholderImageUrl;
  final Map<String, double>? coordinates; // {latitude: double, longitude: double}
  final AiAnalysisResult? aiAnalysis; // AI analysis results

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
    this.pointsRedeemed = false,
    this.imagePath,
    this.imageUrl,
    required this.submittedBy,
    required this.placeholderImageUrl,
    this.coordinates,
    this.aiAnalysis,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'pointsRedeemed': pointsRedeemed,
    'imagePath': imagePath,
    'imageUrl': imageUrl,
    'submittedBy': submittedBy,
    'placeholderImageUrl': placeholderImageUrl,
    'coordinates': coordinates,
    'aiAnalysis': aiAnalysis?.toJson(),
  };

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      status: IssueStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      pointsRedeemed: json['pointsRedeemed'] ?? false,
      imagePath: json['imagePath'],
      imageUrl: json['imageUrl'],
      submittedBy: json['submittedBy'] ?? 'Anonymous',
      placeholderImageUrl: json['placeholderImageUrl'] ?? 'https://via.placeholder.com/150/2196F3/FFFFFF?text=Issue',
      coordinates: json['coordinates'] != null ? Map<String, double>.from(json['coordinates']) : null,
      aiAnalysis: json['aiAnalysis'] != null ? AiAnalysisResult.fromJson(json['aiAnalysis']) : null,
  );
}


