

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double? rating;
  final double? quickSellPrice;
  final double? minimumBid;
  final String condition;
  final bool isPopular;

  Product({
    required this.id,
    required this.images,
    this.rating,
    this.isPopular = false,
    required this.title,
    required this.condition,
    required this.description,
    this.quickSellPrice,
    this.minimumBid,
  });

  
}
