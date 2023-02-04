import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/screens/home_screen.dart';

import '../state/state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    if (usernameController.text == '' || passwordController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')));
      return;
    }
    // print(usernameController.text);
    // print(passwordController.text);
    bool isLogin = await Provider.of<CustomState>(context, listen: false)
        .loginNow(usernameController.text, passwordController.text);
    if (!isLogin) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login error")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NITCIAN",
              style: TextStyle(color: Colors.white, fontSize: 72),
            ),
            TextField(
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              controller: usernameController,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Email',
              ),
            ),
            TextField(
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                hintStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () {
                _login();
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
