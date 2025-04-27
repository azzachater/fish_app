class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final int stock;
  final String image;
  final String category;
  final String userId; // Ajout du propriétaire
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
    required this.userId, // Ajouté comme paramètre requis
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
        userId: '1', // Ajouté pour les samples
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
        userId: '2', // Ajouté pour les samples
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
    String? userId,
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
      userId: userId ?? this.userId, // Ajouté dans copyWith
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  /// Convertir depuis JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['image'] != null) {
      imageUrl = json['image'].toString().contains('http')
          ? json['image'].toString()
          : 'http://192.168.3.18:8000/storage/${json['image']}';
    }

    return Product(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Produit sans nom',
      description: json['description']?.toString() ?? 'Aucune description',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString() ?? '€',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      image: imageUrl,
      category: json['category']?.toString() ?? 'Autre',
      userId: json['user_id']?.toString() ?? '0', // Ajouté depuis JSON
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
      'user_id': userId, // Ajouté dans le JSON
      'is_popular': isPopular,
      'is_favorite': isFavorite,
      'quantity': quantity,
    };
  }
}