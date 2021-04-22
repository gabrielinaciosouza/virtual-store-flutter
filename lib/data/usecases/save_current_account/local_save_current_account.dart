import '../../cache/cache.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.save(key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
