import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String error = '';
  Future<void> loginWithCredentials() async {
    final response = await http.post(
      Uri.parse('https://tuservicio.com/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': userController.text,
        'password': passController.text,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Navigator.pushReplacement(

        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userData: data)),
      );
    } else {
      setState(() => error = 'Credenciales inválidas');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: userController, decoration:
            InputDecoration(labelText: 'Usuario')),
            TextField(controller: passController, obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginWithCredentials,
              child: Text('Ingresar con usuario y contraseña'),
            ),
            if (error.isNotEmpty) Text(error, style: TextStyle(color:
            Colors.red)),
          ],
        ),
      ),
    );
  }
}