import 'package:desafio_nextar/ui/helpers/helpers.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  ValidationError validate({required String? field, required String? value});
}

class GetxLoginPresenter extends GetxController {
  final Validation validation;

  var _emailError = Rx<UIError>(UIError.none);
  var _isFormValid = false.obs;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<bool?>? get isFormValidStream => _isFormValid.stream;

  GetxLoginPresenter({required this.validation});
  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == UIError.none;
  }

  UIError _validateField({String? field, String? value}) {
    final error = validation.validate(field: field, value: value);
    print(error.toString());
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      case ValidationError.none:
        return UIError.none;
      default:
        return UIError.none;
    }
  }
}

enum ValidationError { requiredField, invalidField, none }

class ValidationSpy extends Mock implements Validation {
  @override
  ValidationError validate({required String? field, required String? value}) =>
      this.noSuchMethod(Invocation.method(#validate, [field, value]),
          returnValue: ValidationError.none,
          returnValueForMissingStub: ValidationError.none);
}

void main() {
  late GetxLoginPresenter sut;
  late ValidationSpy validation;
  late String email;

  void mockValidation({
    required String value,
    required String field,
    required error,
  }) {
    when(validation.validate(field: field, value: value)).thenReturn(error);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxLoginPresenter(validation: validation);
    email = 'any_email@mail.com';
  });
  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test(
      'Should emit email error if validation returns ValidationError.invalidField',
      () {
    mockValidation(
        field: 'email', value: email, error: ValidationError.invalidField);

    sut.emailErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
