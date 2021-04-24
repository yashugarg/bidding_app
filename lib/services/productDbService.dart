import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/services/firebase_messaging.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDBServices {
  String? uid;
  late CollectionReference productsRef;

  ProductDBServices({required String? uid}) {
    this.uid = uid;
    productsRef = FirebaseFirestore.instance.collection('products');
  }

  Future<Product> getOneProduct(String id) async {
    DocumentSnapshot snapshot = await productsRef.doc(id).get();
    return Product.fromDocument(snapshot);
  }

  Future addToFavorites({required Product product}) async {
    await productsRef.doc(product.id).update(
      {
        'likes': FieldValue.arrayUnion([uid])
      },
    );
    String? notificationToken =
        await UserDBServices().getNotificationToken(product.userID);
    if (notificationToken != null)
      FirebaseMessage().sendAndRetrieveMessage(
          notificationToken, 'Bidder', 'Someone liked your product.',
          data: <String, String?>{
            'feature': 'product',
            'subfeature': 'like',
            'productId': product.id,
            'imageUrl': "",
          });
  }

  Future removeFromFavorites({
    required String productId,
  }) async {
    return productsRef.doc(productId).update(
      {
        'likes': FieldValue.arrayRemove([uid])
      },
    );
  }

  Stream<List<Product>> fetchMyProducts() {
    return productsRef
        .where('userID', isEqualTo: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap<List<Product>>((event) =>
            event.docs.map<Product>((d) => Product.fromDocument(d)).toList());
  }

  Stream<List<Product>> fetchFavoriteProducts() {
    return productsRef
        .where('likes', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap<List<Product>>((event) =>
            event.docs.map<Product>((d) => Product.fromDocument(d)).toList());
  }

  Future removePost(String id) async {
    return productsRef.doc(id).delete();
  }
}
