import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './factories/pages/pages.dart';

import '../ui/pages/pages.dart';
import '../ui/components/app_theme.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return GetMaterialApp(
        title: 'Desafio Nextar',
        theme: makeAppTheme(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        getPages: [
          GetPage(
              name: '/login',
              page: makeLoginPage,
              transition: Transition.fadeIn),
        ],
        home: LoginPage(makeGetxLoginPresenter()));
  }
}
