import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:loja_virtual/infra/image/image.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSpy extends Mock implements ImagePicker {
  final PickedFile pickedFile;
  ImagePickerSpy({required this.pickedFile});
  @override
  Future<PickedFile?> getImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) =>
      this.noSuchMethod(
          Invocation.method(#getImage, [
            source,
            maxWidth,
            maxHeight,
            imageQuality,
            preferredCameraDevice
          ]),
          returnValue: Future.value(pickedFile),
          returnValueForMissingStub: Future.value(pickedFile));
}

void main() {
  late ImagePickerSpy imagePicker;
  late ImagePickerAdapter sut;
  late PickedFile pickedFile;

  setUp(() {
    pickedFile = PickedFile('any_path');
    imagePicker = ImagePickerSpy(pickedFile: pickedFile);
    sut = ImagePickerAdapter(picker: imagePicker);
  });

  test('Should call functions with correct values', () async {
    await sut.pickFromCamera();
    await sut.pickFromDevice();

    verify(imagePicker.getImage(source: ImageSource.gallery));
    verify(imagePicker.getImage(source: ImageSource.camera));
  });

  test('Should return a file on success', () async {
    final file = await sut.pickFromCamera();

    expect(file, TypeMatcher<File>());
    expect('any_path', file!.path);
  });

  test('Should return a file on success', () async {
    final file = await sut.pickFromDevice();

    expect(file, TypeMatcher<File>());
    expect('any_path', file!.path);
  });

  test('Should throw if ImagePicker throws', () async {
    when(imagePicker.getImage(source: ImageSource.gallery))
        .thenThrow(Exception());

    final future = sut.pickFromDevice();

    expect(future, throwsA(TypeMatcher<Exception>()));
  });

  test('Should throw if ImagePicker throws', () async {
    when(imagePicker.getImage(source: ImageSource.camera))
        .thenThrow(Exception());

    final future = sut.pickFromCamera();

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
