import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String userID;
  final String title;
  final String description;
  final String category;
  final String? subcategory;
  final String condition;
  final double? quickSellPrice;
  final double? minimumBid;
  final DateTime? biddingTime;
  final List<String> images;
  final List<String> likes;
  final bool isPopular;
  final bool isVerified;
  final DateTime publishedAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    required this.condition,
    this.quickSellPrice,
    this.minimumBid,
    this.biddingTime,
    this.isPopular = false,
    required this.isVerified,
    required this.images,
    required this.likes,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc.id,
      userID: doc.data()!['userID'].toString(),
      title: doc.data()!['title'],
      description: doc.data()!['description'],
      condition: doc.data()!['condition'],
      category: doc.data()!['category'],
      subcategory: doc.data()!['subcategory'],
      quickSellPrice: doc.data()!['quickSellPrice'],
      minimumBid: doc.data()!['minimumBid'],
      biddingTime: doc.data()!['biddingTime'] != null
          ? DateTime.parse(
              (doc.data()!['biddingTime'] as Timestamp).toDate().toString())
          : null,
      isPopular: doc.data()!['isPopular'] ?? false,
      images: doc.data()!['images'],
      likes: doc.data()!['likes'],
      isVerified: doc.data()!['isVerified'],
      publishedAt: DateTime.parse(
          (doc.data()!['publishedAt'] as Timestamp).toDate().toString()),
      updatedAt: DateTime.parse(
          (doc.data()!['updatedAt'] as Timestamp).toDate().toString()),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userID': userID,
        'title': title,
        'description': description,
        'condition': condition,
        'category': category,
        'subcategory': subcategory,
        'quickSellPrice': quickSellPrice,
        'minimumBid': minimumBid,
        'biddingTime': biddingTime,
        'isPopular': isPopular,
        'images': images,
        'likes': likes,
        'isVerified': isVerified,
        'publishedAt': publishedAt,
        'updatedAt': updatedAt,
      };
}
