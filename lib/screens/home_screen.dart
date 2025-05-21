import	'package:flutter/material.dart';
import	'package:firebase_auth/firebase_auth.dart';
import	'../services/auth_service.dart';
import	'login_screen.dart';
import	'product_list_screen.dart';

class	HomeScreen	extends	StatelessWidget	{

  final	dynamic	userData;
  final	AuthService	authService	=	AuthService();
  HomeScreen({required	this.userData});

  @override
  Widget build(BuildContext	context)	{
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido	${userData['name']}'),
        actions: [
          IconButton(
            icon:	Icon(Icons.logout),
            onPressed:	()	async	{
              await	authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder:	(_)	=>	LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Center(child: Text('Panel Principal')),	//ProductListScreen(),
    );
  }
}