import 'package:loja_virtual/ui/helpers/helpers.dart';

abstract class LoginPresenter {
  Stream<UIError?>? get emailErrorStream;
  Stream<UIError?>? get passwordErrorStream;
  Stream<UIError?>? get mainErrorStream;
  Stream<bool?>? get isFormValidStream;
  Stream<bool?>? get isLoadingStream;
  Stream<String?>? get navigateToStream;

  void validateEmail(String email);
  void validatePassword(String password);

  Future<void> auth();
}
