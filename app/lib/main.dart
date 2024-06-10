import 'dart:convert';
import 'package:app/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/pages/userlist.dart';

void main() => runApp(const MyApp());
String username = '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      home: const LoginPage(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => const LoginPage(),
        '/sign_up': (BuildContext context) => const SignUp(),
        '/userlist': (BuildContext context) => const UserList(),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();

  String mensaje = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.39/studentnotes/login.php"),
      body: {
        'user': controllerUser.text,
        'password': controllerPass.text,
      },
    );

    var datauser = json.decode(response.body);

    setState(() {
      if (datauser.length == 0) {
        mensaje = "usuario o contraseña incorrectas";
      } else {
        Navigator.pushReplacementNamed(context, '/userlist');
        mensaje = "Login exitoso";
        username = datauser[0]['user'];
      }
    });
  }

  //Diseño de la página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          colors: [
            Color(0xFF00FF00),
            Color(0xFF3C3C3B),
          ],
          center: Alignment.center,
          radius: 0.8,
        )),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80.0, left: 30.0),
                child: Text(
                  'Welcome\nSign In',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 230.0, bottom: 100.0, left: 20.0, right: 20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 3.0),
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            color: Colors.transparent,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: controllerUser,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Username',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: controllerPass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.visibility_off,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 15),
                    ),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const Spacer(),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/sign_up');
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FF00),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
