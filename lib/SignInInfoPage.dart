import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'main.dart';

class SignInInfoPage extends StatefulWidget {
  final String email;

  const SignInInfoPage(this.email, {super.key});

  @override
  State<SignInInfoPage> createState() => _SignInInfoPageState();
}

class _SignInInfoPageState extends State<SignInInfoPage> {
  final nameTextController = TextEditingController();
  final pwTextController = TextEditingController();
  final pwcTextController = TextEditingController();
  final telTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ourColor,
        body: Container(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('회원가입',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const Text('\n'),
              TextField(
                  controller: nameTextController,
                  decoration: const InputDecoration(labelText: '이름')),
              TextField(
                  controller: pwTextController,
                  decoration: const InputDecoration(labelText: '비밀번호')),
              TextField(
                  controller: pwcTextController,
                  decoration: const InputDecoration(labelText: '비밀번호 확인')),
              TextField(
                  controller: telTextController,
                  decoration: const InputDecoration(labelText: '전화번호')),
              const Text('\n'),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      if (pwTextController.text == pwcTextController.text) {
                        var a = await callAPI('/api/join', {
                          "email": widget.email,
                          "password": pwTextController.text,
                          "userName": nameTextController.text,
                          "phoneNumber": telTextController.text
                        });
                        if (a == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        } else {
                          deleteAuth();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      }
                    },
                    child: const Text("회원가입")),
              )
            ],
          ),
        ));
  }
}