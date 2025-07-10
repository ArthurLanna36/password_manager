// lib/vault/vault_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_manager/models/service.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/services/encryption_service.dart'; // Import the service

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EncryptionService _encryptionService = EncryptionService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('services')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Your saved passwords will appear here.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final service =
                  Service.fromMap(doc.id, doc.data() as Map<String, dynamic>);
              return ListTile(
                title: Text(service.name),
                subtitle: Text(service.username),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    // Decrypt password before copying to clipboard
                    final decryptedPassword =
                        await _encryptionService.decrypt(service.password);
                    if (!context.mounted) return;
                    Clipboard.setData(ClipboardData(text: decryptedPassword));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password copied to clipboard!')),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPasswordDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPasswordDialog(BuildContext context) {
    final TextEditingController serviceNameController =
        TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text('Add New Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: serviceNameController,
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                  ),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Login',
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addService(
                    serviceNameController.text,
                    usernameController.text,
                    passwordController.text,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addService(String name, String username, String password) async {
    if (name.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      // Encrypt the password before sending it to Firestore
      final encryptedPassword = await _encryptionService.encrypt(password);

      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('services')
          .add({
        'name': name,
        'username': username,
        'password': encryptedPassword, // Save the encrypted password
      });
    }
  }
}