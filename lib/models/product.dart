class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String stock;
  final String image;
  final bool isPopular;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.stock,
    required this.image,
    this.quantity = 1,
    this.isPopular = false,
  });

  /// Liste de produits de test
  static List<Product> products() {
    return [
      Product(
        id: '1',
        name: 'Canne à pêche',
        description: 'tres bonne etat',
        price: 1.10,
        unit: '€ / pièce',
        stock: "1",
        image: 'assets/images/produit1.png',
      ),
      Product(
        id: '2',
        name: "Sac de pêche",
        description: 'etat  neuf',
        price: 1.85,
        unit: "€ / kg",
        stock: "2",
        image: "assets/images/produit2.png",
      ),
    ];
  }

  /// Permet de créer une nouvelle copie de l'objet avec des valeurs mises à jour.
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      unit: unit,
      stock: stock,
      image: image,
      quantity:
          quantity ?? this.quantity, // Garde l'ancienne valeur si non spécifiée
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
    );
  }
}
