class Product {
  String name;
  double price;
  String? imagePath;

  Product({required this.name, required this.price, required this.imagePath});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }
}
