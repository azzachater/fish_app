class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String stock;
  final String image;
  final bool isPopular;
  bool isFavorite; // Nouveau champ
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.stock,
    required this.image,
    this.isFavorite = false, // Initialisation par défaut
    this.quantity = 1,
    this.isPopular = false,
    required String category,
  });

  /// Liste de produits de test
  static List<Product> products() {
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
        category: 'Accesoires',
      ),
    ];
  }

  /// Permet de créer une nouvelle copie de l'objet avec des valeurs mises à jour.
  Product copyWith({int? quantity, bool? isFavorite}) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      unit: unit,
      stock: stock,
      image: image,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category, // Garde la valeur actuelle
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      unit: json['unit'],
      stock: json['stock'],
      image: json['image'],
      category: json['category'],
    );
  }

  get category => null;
}
