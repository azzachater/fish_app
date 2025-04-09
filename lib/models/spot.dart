class Spot {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String fishSpecies;
  final String recommendedTechniques;
  final String? depth; // Optionnel

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
      id: json['id'] as int?,
      name: json['name']?.toString() ?? 'Sans nom',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      description: json['description']?.toString() ?? '',
      fishSpecies: json['fish_species']?.toString() ?? '',
      recommendedTechniques: json['recommendedTechniques']?.toString() ?? '',
      depth: json['depth']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'fish_species': fishSpecies,
      'recommendedTechniques': recommendedTechniques,
      if (depth != null) 'depth': depth,
    };
  }
}
