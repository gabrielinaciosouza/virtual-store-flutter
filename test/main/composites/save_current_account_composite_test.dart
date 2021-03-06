import 'package:loja_virtual/data/usecases/save_current_account/save_current_account.dart';
import 'package:loja_virtual/data/usecases/usecases.dart';
import 'package:loja_virtual/domain/entities/account_entity.dart';
import 'package:loja_virtual/main/composites/composites.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class SecureLocalSaveCurrentAccountSpy extends Mock
    implements SecureLocalSaveCurrentAccount {
  @override
  Future<void> save(AccountEntity account) =>
      this.noSuchMethod(Invocation.method(#save, []),
          returnValue: Future.value(),
          returnValueForMissingStub: Future.value());
}

class LocalSaveCurrentAccountSpy extends Mock
    implements LocalSaveCurrentAccount {
  @override
  Future<void> save(AccountEntity account) =>
      this.noSuchMethod(Invocation.method(#save, []),
          returnValue: Future.value(),
          returnValueForMissingStub: Future.value());
}

void main() {
  late SaveCurrentAccountComposite sut;
  late SecureLocalSaveCurrentAccount secure;
  late LocalSaveCurrentAccountSpy local;
  late AccountEntity accountEntity;

  setUp(() {
    secure = SecureLocalSaveCurrentAccountSpy();
    local = LocalSaveCurrentAccountSpy();
    sut = SaveCurrentAccountComposite(secure: secure, local: local);
    accountEntity = AccountEntity(token: 'any_token');
  });

  void throwSecureError() {
    when(secure.save(accountEntity)).thenThrow(Exception());
  }

  void throwLocalError() {
    when(local.save(accountEntity)).thenThrow(Exception());
  }

  test('Should call secure save', () async {
    await sut.save(accountEntity);

    verify(secure.save(accountEntity));
  });

  test('Should call local save if secure fails', () async {
    throwSecureError();
    await sut.save(accountEntity);

    verify(local.save(accountEntity)).called(1);
  });

  test('Should throw if local throws', () async {
    throwSecureError();
    throwLocalError();
    final future = sut.save(accountEntity);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
