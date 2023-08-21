import 'package:buyer/domain/entities/product_entities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiClient {
  final String baseUrl = "/initial_app_test";

  Stream<QuerySnapshot<Map<String, dynamic>>> get(String endpoint) {
    final forId = FirebaseFirestore.instance.collection('$baseUrl');

    final products = forId.snapshots();

    return products;
  }
}
