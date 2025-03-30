class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String stock;
  final String image;
  final String category;
  final bool isPopular;
  bool isFavorite;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.stock,
    required this.image,
    required this.category,
    this.isFavorite = false,
    this.quantity = 1,
    this.isPopular = false,
  });

  /// Liste de produits de test
  static List<Product> sampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Canne à pêche',
        description: 'Très bon état',
        price: 1.10,
        unit: '€ / pièce',
        stock: "1",
        image: 'assets/images/produit1.png',
        category: 'Cannes',
      ),
      Product(
        id: '2',
        name: "Sac de pêche",
        description: 'État neuf',
        price: 1.85,
        unit: "€ / kg",
        stock: "2",
        image: "assets/images/produit2.png",
        category: 'Accessoires',
      ),
    ];
  }

  /// Permet de créer une nouvelle copie de l'objet avec des valeurs mises à jour
  Product copyWith({
    int? quantity,
    bool? isFavorite,
    String? id,
    String? name,
    String? description,
    double? price,
    String? unit,
    String? stock,
    String? image,
    String? category,
    bool? isPopular,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      unit: json['unit'] ?? '€ / pièce',
      stock: json['stock']?.toString() ?? '0',
      image: json['image'] ?? 'assets/images/default.png',
      category: json['category'] ?? 'Autre',
      isPopular: json['is_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'stock': stock,
      'image': image,
      'category': category,
      'is_popular': isPopular,
    };
  }
}
