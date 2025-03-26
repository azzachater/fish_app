class Product {
  final String id;
  final String name;
  final double price;
  final String unit;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.quantity = 1,
  });

  /// Liste de produits de test
  static List<Product> products() {
    return [
      Product(
        id: '1',
        name: 'Canne à pêche',
        price: 1.10,
        unit: '€ / pièce',
        imageUrl: 'assets/images/produit1.png',
      ),
      Product(
        id: '2',
        name: "Sac de pêche",
        price: 1.85,
        unit: "€ / kg",
        imageUrl: "assets/images/produit2.png",
      ),
    ];
  }

  /// Permet de créer une nouvelle copie de l'objet avec des valeurs mises à jour.
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
      quantity:
          quantity ?? this.quantity, // Garde l'ancienne valeur si non spécifiée
    );
  }
}
