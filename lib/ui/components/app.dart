import 'package:desafio_nextar/ui/components/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      title: 'Desafio Nextar',
      theme: makeAppTheme(),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
