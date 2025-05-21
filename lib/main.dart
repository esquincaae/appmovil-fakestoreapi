import 'package:flutter/material.dart';
import 'data/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../screens/cart_screens.dart';
import	'package:firebase_core/firebase_core.dart';
import	'package:firebase_auth/firebase_auth.dart';
import	'screens/home_screen.dart';
import	'screens/login_screen.dart';

void	main()	async	{
  WidgetsFlutterBinding.ensureInitialized();
  await	Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "XXX",
                              appId: "XXX",
                              messagingSenderId: "XXX",
                              projectId: "XXX"
    ),
  );
  final	user = FirebaseAuth.instance.currentUser;
  runApp(MaterialApp(
    debugShowCheckedModeBanner:	false,
    home:	user	==	null	?	LoginScreen()	:	HomeScreen(userData:	user),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            );
          }
        },
      ),
    );
  }
}