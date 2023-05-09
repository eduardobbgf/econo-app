import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentsListWidget extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  DocumentsListWidget({required this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = documents[index];
        String title = document.get('title');
        String category = document.get('category');
        int amount = document.get('amount');
        // Use the document data to display the content of each item in the list

        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount: \$${amount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Category: $category'),
              ],
            ),
          ),
        );
      },
    );
  }
}
