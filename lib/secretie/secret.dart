import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = new FlutterSecureStorage();

class keeperOfSecrets {
  final _storage = new FlutterSecureStorage();
  final _key = 'somethingVerryFuckingSecretBaby';
  final _value = '6f5a65a3c300415081479a0a1d4aa956';

  Future<void> _secretMaker() async {
    await _storage.write(key: _key, value: _value);
  }

  Future<String> secretGiver() async {
    await _secretMaker();
    return _storage.read(key: _key);
  }
}
