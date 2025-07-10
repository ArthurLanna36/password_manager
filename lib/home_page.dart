// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: "PasswordManager",
      publicKey: "PasswordManager",
    ),
  );

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();
              // Delete the session from secure storage
              await _storage.delete(key: 'user_session');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user?.email}!'),
          ],
        ),
      ),
    );
  }
}