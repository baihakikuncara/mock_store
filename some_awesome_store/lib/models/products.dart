class Product {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product(this.id, this.title, this.price, this.description,
      this.category, this.image, this.rating);

  factory Product.fromJson(Map json) {
    Rating rating =
        Rating(json['rating']?['rate'] ?? 0.0, json['rating']?['count'] ?? 0);
    return Product(
        json['id'] ?? -1,
        json['title'] ?? '',
        json['price'] ?? 0.0,
        json['description'] ?? '',
        json['category'] ?? '',
        json['image'] ?? '',
        rating);
  }

  @override
  String toString() {
    return 'id:$id, title:$title';
  }
}

class Rating {
  final num rate;
  final int count;

  const Rating(this.rate, this.count);
}
