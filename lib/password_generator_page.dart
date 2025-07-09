import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  double _passwordLength = 12.0;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  bool _useUppercase = true;
  String _generatedPassword = '';

  void _generatePassword() {
    final random = Random.secure();
    final chars = StringBuffer();
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    chars.write(lowercaseChars);
    if (_useUppercase) chars.write(uppercaseChars);
    if (_useNumbers) chars.write(numbers);
    if (_useSpecialChars) chars.write(specialChars);

    final allChars = chars.toString();
    if (allChars.isEmpty) return;

    final password = List.generate(_passwordLength.toInt(), (index) {
      final randomIndex = random.nextInt(allChars.length);
      return allChars[randomIndex];
    }).join();

    setState(() {
      _generatedPassword = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Generator"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Password Length: ${_passwordLength.toInt()}',
                  style: const TextStyle(fontSize: 16)),
              Slider(
                value: _passwordLength,
                min: 4,
                max: 32,
                divisions: 28,
                label: _passwordLength.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _passwordLength = value;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Include Uppercase Letters'),
                value: _useUppercase,
                onChanged: (bool? value) {
                  setState(() {
                    _useUppercase = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Include Numbers'),
                value: _useNumbers,
                onChanged: (bool? value) {
                  setState(() {
                    _useNumbers = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Include Special Characters'),
                value: _useSpecialChars,
                onChanged: (bool? value) {
                  setState(() {
                    _useSpecialChars = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _generatePassword,
                  child: const Text('Generate Password'),
                ),
              ),
              const SizedBox(height: 20),
              if (_generatedPassword.isNotEmpty)
                Column(
                  children: [
                    const Text(
                      'Generated Password:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _generatedPassword,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'monospace'),
                              softWrap: true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: _generatedPassword));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Password copied to clipboard!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}