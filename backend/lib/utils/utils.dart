import 'package:encrypt/encrypt.dart';

class Utils {
  static Encrypted encryptAES(String inputKey, String plainText) {
    final key = Key.fromUtf8(inputKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted;
  }

  static String decryptAES(String inputKey, String encryptedData) {
    final key = Key.fromUtf8(inputKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    String decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv);
    return decrypted;
  }
}
