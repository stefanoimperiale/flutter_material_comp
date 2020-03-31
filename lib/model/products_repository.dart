import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:materialbasic/model/product.dart';

class ProductRepository {

  static Stream<QuerySnapshot> loadProducts(Category category) {
    if (category == Category.all) {
    return Firestore.instance
          .collection('products')
          .snapshots();
    } else {
      return Firestore.instance.collection('products')
          .where('category', isEqualTo: category.index)
          .snapshots();
    }
  }

}
