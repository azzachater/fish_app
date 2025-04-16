class Spot {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String fishSpecies;
  final String recommendedTechniques;
  final double? depth;

  Spot({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.fishSpecies,
    required this.recommendedTechniques,
    this.depth,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
  return Spot(
    id: int.tryParse(json['id']?.toString() ?? ''),
    name: json['name']?.toString() ?? 'Sans nom',
    latitude: _convertToDouble(json['latitude']),
    longitude: _convertToDouble(json['longitude']),
    description: json['description']?.toString() ?? '',
    fishSpecies: json['fish_species']?.toString() ?? '',
    recommendedTechniques: json['recommended_techniques']?.toString() ?? '',
    depth: _convertToDouble(json['depth']),
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
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'fish_species': fishSpecies,
      'recommended_techniques': recommendedTechniques,
      if (depth != null) 'depth': depth,
    };
  }
}