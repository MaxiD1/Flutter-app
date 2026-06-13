import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> buyBook({
    required String bookId,
    required String title,
    required String author,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    await _db.collection('purchases').add({
      'userID': user.uid,
      'bookID': bookId,
      'title': title,
      'author': author,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getUserPurchases() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('purchases')
        .where('userID', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }
}