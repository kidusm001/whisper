import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

class ContentEncryptionService {
  static String generateEncryptionKey() {
    final key = encrypt.Key.fromSecureRandom(32);
    return key.base64;
  }

  static String encryptText(String plainText, String keyBase64) {
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static String decryptText(String encryptedText, String keyBase64) {
    try {
      final key = encrypt.Key.fromBase64(keyBase64);
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      return encrypter.decrypt64(encryptedText, iv: iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  static Future<Uint8List> encryptMedia(
      Uint8List data, String keyBase64) async {
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.encryptBytes(data, iv: iv).bytes;
  }

  static Future<Uint8List> decryptMedia(
      Uint8List encryptedData, String keyBase64) async {
    final key = encrypt.Key.fromBase64(keyBase64);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return Uint8List.fromList(
        encrypter.decryptBytes(encrypt.Encrypted(encryptedData), iv: iv));
  }
}
