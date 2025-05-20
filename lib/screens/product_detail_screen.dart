import 'package:flutter/material.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle del Producto')),
      body: FutureBuilder<Product>(
        future: fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(product.image, height: 200),
                  SizedBox(height: 16),
                  Text(product.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.green)),
                  SizedBox(height: 16),
                  Text(product.description),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener detalle del producto');
    }
  }
}
