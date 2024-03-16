import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final XFile? selected =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = selected;
    });

    if (_imageFile != null) {
      final File file = File(_imageFile!.path);
      // ignore: use_build_context_synchronously
      await uploadImageToFirebase(context, file);
    }
  }

  Future<void> uploadImageToFirebase(BuildContext context, File file) async {
    String fileName = FirebaseAuth.instance.currentUser!.uid;
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await storage.ref('uploads/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 12,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(File(_imageFile!.path)) as ImageProvider<Object>?
                  : (FirebaseAuth.instance.currentUser!.photoURL != null &&
                          FirebaseAuth
                              .instance.currentUser!.photoURL!.isNotEmpty)
                      ? NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!)
                      : const AssetImage('assets/user.png') as ImageProvider<
                          Object>, // Replace 'assets/profile.png' with your asset's path
            ),
            const SizedBox(
              height: 12,
            ),
            Text(FirebaseAuth.instance.currentUser!.email ?? ''),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Profil resmini değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}
