
import 'dart:ui';
import 'package:flutter/material.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
      ),
      body: const Center(
        child: Text('Your saved passwords will appear here.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPasswordDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPasswordDialog(BuildContext context) {
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
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Login',
                  ),
                ),
                TextField(
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
                  // Add logic to save the password
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
}
