import '../../../domain/helpers/helpers.dart';

import '../../../domain/entities/entities.dart';

import '../../cache/cache.dart';

import '../../../domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchCacheStorage fetchCacheStorage;

  LocalLoadCurrentAccount({required this.fetchCacheStorage});
  Future<AccountEntity> load() async {
    try {
      final token = await fetchCacheStorage.fetch('token');
      return AccountEntity(token: token!);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
