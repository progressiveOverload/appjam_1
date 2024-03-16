import 'package:appjam_1/screens/giris_yap.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Import Get library

class KayitOlScreen extends StatefulWidget {
  const KayitOlScreen({Key? key}) : super(key: key);

  @override
  KayitOlScreenState createState() => KayitOlScreenState();
}

class KayitOlScreenState extends State<KayitOlScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Show a snackbar
      Get.snackbar(
        'Kayıt Başarılı', // title
        'Giriş ekranına yönlendiriliyorsun', // message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(12)
      );

      // Delay navigation to show the snackbar
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to the sign-up page
      Get.offAll(() => const GirisScreen()); // Use Get to navigate
    } catch (e) {
      // Handle errors here, e.g., show error message to the user
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
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
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: _submitForm,
                    child: const Text('Kayıt Ol'),
                  ),
          ],
        ),
      ),
    );
  }
}
