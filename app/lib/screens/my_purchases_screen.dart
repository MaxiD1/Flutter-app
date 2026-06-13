import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPurchasesScreen extends StatelessWidget {
  const MyPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("No logueado"));
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('purchases')
          .where('userID', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        print(snapshot.data?.docs.length);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Sin compras"));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['title'] ?? ''),
              subtitle: Text(data['author'] ?? ''),
            );
          },
        );
      },
    );
  }
}