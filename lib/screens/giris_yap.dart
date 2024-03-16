import 'package:appjam_1/screens/kayit_ol.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'main_menu.dart'; // Import Get library

class GirisScreen extends StatefulWidget {
  const GirisScreen({Key? key}) : super(key: key);

  @override
  GirisScreenState createState() => GirisScreenState();
}

class GirisScreenState extends State<GirisScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to the main menu after successful login using Get
      Get.to(() => const MainMenu());
      Get.snackbar(
        'Hoşgedin', // title
        'Başarılı bir şekilde giriş yaptınız!', // message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors here, e.g., show error message to the user
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToSignUpScreen() {
    Get.to(() => const KayitOlScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: _submitForm,
                    child: const Text('Giriş Yap'),
                  ),
            TextButton(
              onPressed: _goToSignUpScreen,
              child: const Text('Hesabın yok mu, Kayıt ol!'),
            ),
          ],
        ),
      ),
    );
  }
}
