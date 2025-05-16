import 'package:latlong2/latlong.dart';

class Spot {
  final int? id;
  final String name;
  final LatLng position;
  final String description;
  final String fishSpecies;
  final String recommendedTechniques;
  final double? depth;
  final double? score;
  final int upvotes;
  final int downvotes;
  final List<String> voterIds;
  final bool isHidden;

  Spot({
    this.id,
    required this.name,
    required this.position,
    required this.description,
    required this.fishSpecies,
    required this.recommendedTechniques,
    this.depth,
    this.score,
    this.upvotes = 0,
    this.downvotes = 0,
    List<String>? voterIds,
    this.isHidden = false,
  }) : voterIds = voterIds ?? [];

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
      upvotes: (json['upvotes'] ?? 0) as int, // Conversion sécurisée
      downvotes: (json['downvotes'] ?? 0) as int,
      voterIds: List<String>.from(json['voter_ids'] ?? []),
      isHidden: json['is_hidden'] ?? false,
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
      'latitude': position.latitude,
      'longitude': position.longitude,
      'description': description,
      'fish_species': fishSpecies,
      'recommended_techniques': recommendedTechniques,
      if (depth != null) 'depth': depth,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'voter_ids': voterIds,
      'is_hidden': isHidden,
    };
  }

  int get voteScore => upvotes - downvotes;

  String get displayScore =>
      score != null ? '${(score! * 100).round()}%' : 'N/A';

  Spot copyWith({
    int? id,
    String? name,
    LatLng? position,
    String? description,
    String? fishSpecies,
    String? recommendedTechniques,
    double? depth,
    double? score,
    int? upvotes,
    int? downvotes,
    List<String>? voterIds,
    bool? isHidden,
  }) {
    return Spot(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      description: description ?? this.description,
      fishSpecies: fishSpecies ?? this.fishSpecies,
      recommendedTechniques:
          recommendedTechniques ?? this.recommendedTechniques,
      depth: depth ?? this.depth,
      score: score ?? this.score,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      voterIds: voterIds ?? this.voterIds,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}