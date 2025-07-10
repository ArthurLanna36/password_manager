// lib/services/encryption_service.dart
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class EncryptionService {
  final _storage = const FlutterSecureStorage();
  final _log = Logger('EncryptionService');

  Future<Encrypter> _getEncrypter() async {
    final key = await _getOrCreateKey();
    return Encrypter(AES(key));
  }

  Future<Key> _getOrCreateKey() async {
    String? base64Key = await _storage.read(key: 'encryption_key');
    if (base64Key == null) {
      final key = Key.fromSecureRandom(32);
      await _storage.write(key: 'encryption_key', value: key.base64);
      return key;
    }
    return Key.fromBase64(base64Key);
  }

  Future<String> encrypt(String plainText) async {
    final encrypter = await _getEncrypter();
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  Future<String> decrypt(String encryptedText) async {
    try {
      final parts = encryptedText.split(':');
      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);

      final encrypter = await _getEncrypter();
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e, stackTrace) {
      _log.severe('Decryption failed', e, stackTrace);
      return "Decryption Error";
    }
  }
}