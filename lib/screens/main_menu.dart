import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart'; // Import Get library

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle sign-out errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // Prevents the user from going back
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hoşgeldin! \n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Handle item 1 tap
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
              ListTile(
                title: const Text('Çıkış Yap'),
                onTap: () => _signOut(context), // Call _signOut method on tap
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Lokal Gezgin v1.0.0'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
