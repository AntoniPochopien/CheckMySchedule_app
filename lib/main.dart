import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/homePageScreen.dart';
import './provider/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Data(),
      child: MaterialApp(
        title: 'PW App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePageScreen(),
      ),
    );
  }
}
