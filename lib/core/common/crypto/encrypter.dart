import 'dart:convert';

import 'package:e_com/core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart';

class KEncrypter {
  static final KEncrypter _instance = KEncrypter._internal();
  factory KEncrypter() => _instance;
  KEncrypter._internal();

  String encryptWithPublicKey(String data, String key) {
    try {
      final publicKey = CryptoKeyParser(key).toRASPubicKey();

      final encrypter = PKCS1Encoding(RSAEngine())
        ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

      Uint8List dataBytes = Uint8List.fromList(utf8.encode(data));
      Uint8List encryptedBytes = encrypter.process(dataBytes);

      return base64.encode(encryptedBytes);
    } catch (e) {
      return 'encryptData\n$e';
    }
  }

  String decryptWithPrivateKey(String encryptedData, String key) {
    try {
      final rsaPrivateKey = CryptoKeyParser(key).toRASPrivateKey();

      final decrypter = PKCS1Encoding(RSAEngine())
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));

      Uint8List encryptedBytes = base64.decode(encryptedData);
      Uint8List decryptedBytes = decrypter.process(encryptedBytes);

      return utf8.decode(decryptedBytes);
    } catch (e) {
      return 'Error decrypting Data';
    }
  }

  String signWithPrivateKey(String data, String key) {
    try {
      final rsaPrivateKey = CryptoKeyParser(key).toRASPrivateKey();

      final signer = RSASigner(SHA256Digest(), '0609608648016503040201')
        ..init(true, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));

      Uint8List dataBytes = Uint8List.fromList(utf8.encode(data));
      Uint8List signature = signer.generateSignature(dataBytes).bytes;

      return base64.encode(signature);
    } on Exception catch (e) {
      return 'generateSignature\n$e';
    }
  }

  String _bytesToHex(Uint8List bytes) =>
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');

  String generateHashString(String input) {
    final Uint8List data = Uint8List.fromList(utf8.encode(input));

    final Digest sha256Digest = SHA256Digest();
    final Uint8List hashBytes = sha256Digest.process(data);

    final hashString = _bytesToHex(hashBytes);
    return hashString.substring(0, 40);
  }

  bool verifySignature(String data, String signature, String key) {
    final Uint8List dataBytes = Uint8List.fromList(utf8.encode(data));
    final Uint8List signatureBytes = base64.decode(signature);

    final Digest sha256Digest = SHA256Digest();

    final rsaPublicKey = CryptoKeyParser(key).toRASPubicKey();
    final RSASigner signer = RSASigner(sha256Digest, '0609608648016503040201');
    signer.init(false, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));

    return signer.verifySignature(dataBytes, RSASignature(signatureBytes));
  }
}
