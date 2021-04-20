import 'package:flutter/material.dart';

import '../../../../ui/pages/home/home.dart';

Widget makeHomePage() {
  return HomePage(
    presenter: FakePresenter(),
  );
}

class FakePresenter implements HomePresenter {
  //just for compile
  @override
  Future<void> loadProducts() {
    throw UnimplementedError();
  }
}
