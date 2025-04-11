class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final int stock;
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
        name: 'Canne à pêche professionnelle',
        description: 'Très bon état - 2.10m',
        price: 45.99,
        unit: '€',
        stock: 3,
        image: 'assets/images/produit1.png',
        category: 'Cannes',
      ),
      Product(
        id: '2',
        name: 'Moulinet Shimano',
        description: 'Neuf - Ratio 5.2:1',
        price: 89.99,
        unit: '€',
        stock: 5,
        image: 'assets/images/produit2.png',
        category: 'Moulinets',
      ),
    ];
  }

  /// Créer une copie avec des valeurs mises à jour
  Product copyWith({
    int? quantity,
    bool? isFavorite,
    String? id,
    String? name,
    String? description,
    double? price,
    String? unit,
    int? stock,
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

  /// Convertir depuis JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['image'] != null) {
      imageUrl =
          json['image'].toString().contains('http')
              ? json['image'].toString()
              : 'http://10.0.2.2:8000/storage/${json['image']}';
    }

    return Product(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Produit sans nom',
      description: json['description']?.toString() ?? 'Aucune description',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString() ?? '€',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      image: imageUrl, // Utilisez la variable sécurisée
      category: json['category']?.toString() ?? 'Autre',
    );
  }

  /// Convertir en JSON
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
      'is_favorite': isFavorite,
      'quantity': quantity,
    };
  }
}
