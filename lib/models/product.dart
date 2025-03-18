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
}
