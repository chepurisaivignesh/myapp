import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/screens/home_screen.dart';
import 'package:withytcode/screens/login_screen.dart';
import 'package:withytcode/state/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalStorage storage = LocalStorage('usertoken');

    return ChangeNotifierProvider(
      create: (context) => CustomState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Ubuntu'),
        home: FutureBuilder(
          future: storage.ready,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (storage.getItem('token') == null) {
              return LoginScreen();
            } else {
              return HomeScreen();
            }
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
        },
      ),
    );
  }
}
