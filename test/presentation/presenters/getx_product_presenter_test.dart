import 'dart:io';

import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:loja_virtual/domain/helpers/helpers.dart';
import 'package:loja_virtual/domain/entities/entities.dart';
import 'package:loja_virtual/domain/usecases/usecases.dart';

import 'package:loja_virtual/presentation/presenters/presenters.dart';
import 'package:loja_virtual/presentation/protocols/protocols.dart';

import 'package:loja_virtual/ui/helpers/helpers.dart';

class ValidationSpy extends Mock implements Validation {
  @override
  ValidationError validate({required String? field, required String? value}) =>
      this.noSuchMethod(Invocation.method(#validate, [field, value]),
          returnValue: ValidationError.none,
          returnValueForMissingStub: ValidationError.none);
}

class DeleteFromCacheSpy extends Mock implements DeleteFromCache {
  @override
  Future<void> delete(String code) =>
      this.noSuchMethod(Invocation.method(#delete, [code]),
          returnValue: Future.value(),
          returnValueForMissingStub: Future.value());
}

class PickImageSpy extends Mock implements PickImage {
  @override
  Future<File?> pickFromCamera() =>
      this.noSuchMethod(Invocation.method(#pickFromCamera, []),
          returnValue: Future.value(File('any_path')),
          returnValueForMissingStub: Future.value(File('any_path')));

  @override
  Future<File?> pickFromDevice() =>
      this.noSuchMethod(Invocation.method(#pickFromDevice, []),
          returnValue: Future.value(File('any_path')),
          returnValueForMissingStub: Future.value(File('any_path')));
}

class SaveProductSpy extends Mock implements SaveProduct {
  @override
  Future<void> save(ProductEntity product) =>
      this.noSuchMethod(Invocation.method(#save, [product]),
          returnValue: Future.value(),
          returnValueForMissingStub: Future.value());
}

class LoadProductSpy extends Mock implements LoadProduct {
  final ProductEntity productEntity;
  LoadProductSpy({required this.productEntity});
  @override
  Future<ProductEntity> load(String productCode) =>
      this.noSuchMethod(Invocation.method(#save, [productCode]),
          returnValue: Future.value(productEntity),
          returnValueForMissingStub: Future.value(productEntity));
}

void main() {
  late GetxProductPresenter sut;
  late PickImageSpy pickImage;
  late ValidationSpy validation;
  late LoadProductSpy loadProduct;
  late DeleteFromCacheSpy deleteFromCache;
  late SaveProductSpy saveProduct;
  late String code;
  late String name;
  late String price;
  late String stock;
  late ProductEntity product;

  void mockValidation({
    required String value,
    required String field,
    required error,
  }) {
    when(validation.validate(field: field, value: value)).thenReturn(error);
  }

  PostExpectation submitCall() => when(saveProduct.save(product));
  PostExpectation loadProductCall() => when(loadProduct.load(product.code));

  void mockLoadProduct() {
    loadProductCall().thenAnswer((realInvocation) async => product);
  }

  void mockSubmitError({required DomainError error}) {
    submitCall().thenThrow(error);
  }

  setUp(() {
    Get.testMode = true;
    code = 'any_value';
    name = 'any_name';
    price = '10';
    stock = '20';
    CustomizableDateTime.customTime = DateTime.parse("1969-07-20 20:18:04");
    product = ProductEntity(
        name: name,
        code: code,
        imagePath: '',
        creationDate: CustomizableDateTime.current,
        price: price.isEmpty ? null : num.parse(price),
        stock: stock.isEmpty ? null : num.parse(stock));
    validation = ValidationSpy();
    deleteFromCache = DeleteFromCacheSpy();
    saveProduct = SaveProductSpy();
    loadProduct = LoadProductSpy(productEntity: product);
    pickImage = PickImageSpy();
    sut = GetxProductPresenter(
        validation: validation,
        deleteFromCache: deleteFromCache,
        saveProduct: saveProduct,
        loadProductByCode: loadProduct,
        productCode: null,
        pickImage: pickImage);

    sut.price = price;
    sut.stock = stock;
    mockLoadProduct();
  });
  test('Should call Validation code with correct value value', () {
    sut.validateCode(code);
    verify(validation.validate(field: 'code', value: code)).called(1);
  });

  test('Should call Validation name with correct value value', () {
    sut.validateCode(code);
    verify(validation.validate(field: 'code', value: code)).called(1);
  });

  test(
      'Should emit name error if validation returns ValidationError.invalidField',
      () {
    mockValidation(
        field: 'name', value: name, error: ValidationError.invalidField);

    sut.nameErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test(
      'Should emit name error if validation return ValidationError.requiredField',
      () {
    mockValidation(
        field: 'name', value: name, error: ValidationError.requiredField);

    sut.nameErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test('Should emit empty if validation succeeds', () {
    sut.nameErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.none)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    sut.validateCode(code);
    sut.validateName(name);

    verify(validation.validate(field: 'code', value: code)).called(1);
  });

  test(
      'Should emit code error if validation returns ValidationError.invalidField',
      () {
    mockValidation(
        field: 'code', value: code, error: ValidationError.invalidField);

    sut.codeErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateCode(code);
    sut.validateName(name);
  });

  test(
      'Should emit code error if validation return ValidationError.requiredField',
      () {
    mockValidation(
        field: 'code', value: code, error: ValidationError.requiredField);

    sut.codeErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateCode(code);
    sut.validateName(name);
  });

  test('Should emit empty if validation succeeds', () {
    sut.codeErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.none)));
    sut.isFormValidStream!
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateCode(code);
    sut.validateCode(code);
  });

  test('Should emit isFormValid true if validations succeeds', () async {
    sut.nameErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.none)));
    sut.codeErrorStream!
        .listen(expectAsync1((error) => expect(error, UIError.none)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateCode(code);
  });

  test('Should call Submit with correct values on Editing', () async {
    sut.validateName(name);
    sut.validateCode(code);
    sut.isEditing = true;
    sut.productCode = product.code;
    await sut.submit();

    verify(deleteFromCache.delete(code)).called(1);
    verify(saveProduct.save(product));
  });

  test('Should call Submit with correct values on Saving', () async {
    sut.validateCode(code);
    sut.validateName(name);
    sut.isEditing = false;
    await sut.submit();

    verifyNever(deleteFromCache.delete(code));
    verify(saveProduct.save(product)).called(1);
  });

  test('Should emit correct events on Submit success', () async {
    sut.validateCode(code);
    sut.validateName(name);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.submit();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockSubmitError(error: DomainError.unexpected);

    sut.validateCode(code);
    sut.validateName(name);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([UIError.none, UIError.unexpected]));

    await sut.submit();
  });

  test('Should return on success', () async {
    sut.validateCode(code);
    sut.validateName(name);

    sut.navigateToStream!.listen(expectAsync1((page) => expect(page, '/home')));

    await sut.submit();
  });

  test('Should call LoadProduct code with correct value value', () async {
    sut.productCode = product.code;
    await sut.loadProduct();
    verify(loadProduct.load(product.code));
  });

  test('Should return ProductEntity on success', () async {
    sut.productCode = product.code;
    await sut.loadProduct();
    expect(sut.product, product);
  });

  test('Should never call LoadProduct if productCode is empty', () async {
    sut.productCode = '';
    await sut.loadProduct();
    verifyNever(loadProduct.load(''));
  });

  test('Should turn isEditing to true if productCode is not empty', () async {
    sut.productCode = product.code;
    await sut.loadProduct();
    expect(sut.isEditing, true);
  });

  test('Should present error if loadProduct fails', () {
    loadProductCall().thenThrow(Exception());
    sut.productCode = product.code;

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([UIError.none, UIError.unexpected]));

    sut.loadProduct();
  });
}
