import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  String error = '';
  bool isLoading = false;

  // Login con email y contraseña usando Firebase
  Future<void> loginWithCredentials() async {
    if (userController.text.isEmpty || passController.text.isEmpty) {
      setState(() => error = 'Por favor ingresa correo y contraseña');
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userController.text.trim(),
        password: passController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Error de autenticación');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Login con Google usando Firebase
  Future<void> loginWithGoogle() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return; // El usuario canceló
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'Error con Google');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://fakestoreapi.com/icons/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 100),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: userController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                ),
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                SizedBox(height: 20),
                if (isLoading)
                  CircularProgressIndicator()
                else ...[
                  ElevatedButton(
                    onPressed: loginWithCredentials,
                    child: Text('Iniciar Sesión'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: loginWithGoogle,
                    icon: Image.network(
                      'https://img.icons8.com/color/48/google-logo.png',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.white);
                      },
                    ),
                    label: Text('Iniciar con Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()), // Esta pantalla debe existir
                      );
                    },
                    child: Text("¿No tienes cuenta? Regístrate aquí"),
                  ),
                ],
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(error, style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
