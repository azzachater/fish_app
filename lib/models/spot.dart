import 'package:latlong2/latlong.dart';

class Spot {
  final int? id;
  final String name;
  final LatLng position; // Utilisez LatLng directement
  final String description;
  final String fishSpecies;
  final String recommendedTechniques;
  final double? depth;
  final double? score;

  Spot({
    this.id,
    required this.name,
    required this.position,
    required this.description,
    required this.fishSpecies,
    required this.recommendedTechniques,
    this.depth,
    this.score,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? 'Sans nom',
      position: LatLng(
        _convertToDouble(json['latitude']),
        _convertToDouble(json['longitude']),
      ),
      description: json['description']?.toString() ?? '',
      fishSpecies: json['fish_species']?.toString() ?? '',
      recommendedTechniques: json['recommended_techniques']?.toString() ?? '',
      depth: _convertToDouble(json['depth']),
      score: _convertToDouble(json['score']),
    );
  }

  static double _convertToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'position' : position,
      'description': description,
      'fish_species': fishSpecies,
      'recommended_techniques': recommendedTechniques,
      if (depth != null) 'depth': depth,
    };
  }

  String get displayScore => score != null ? '${(score! * 100).round()}%' : 'N/A';
}