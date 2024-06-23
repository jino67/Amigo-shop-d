import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/pointycastle.dart';

class CryptoKeyParser {
  final String key;

  const CryptoKeyParser(this.key);

  RSAPublicKey toRASPubicKey() {
    final publicKeyString =
        '-----BEGIN PUBLIC KEY-----\n$key\n-----END PUBLIC KEY-----';

    final parsedKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;
    return parsedKey;
  }

  RSAPrivateKey toRASPrivateKey() {
    final privateKeyString =
        '-----BEGIN PRIVATE KEY-----\n$key\n-----END PRIVATE KEY-----';

    final parser = RSAKeyParser();
    final parsedKey = parser.parse(privateKeyString) as RSAPrivateKey;

    return parsedKey;
  }
}
