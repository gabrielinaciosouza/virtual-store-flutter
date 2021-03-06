import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter
    implements FetchCacheStorage, SaveCacheStorage, DeleteCacheStorage {
  final LocalStorage storage;

  LocalStorageAdapter({required this.storage});
  @override
  Future<dynamic> fetch(String key) async {
    return await storage.getItem(key);
  }

  @override
  Future<void> save({required String key, required String value}) async {
    return await storage.setItem(key, value);
  }

  @override
  Future<void> delete({required String key}) async {
    return await storage.deleteItem(key);
  }
}
