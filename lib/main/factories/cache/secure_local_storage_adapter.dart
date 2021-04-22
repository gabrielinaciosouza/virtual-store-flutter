import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/cache/secure_local_storage_adapter.dart';

SecureLocalStorageAdapter makeSecureLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();
  return SecureLocalStorageAdapter(secureStorage: secureStorage);
}