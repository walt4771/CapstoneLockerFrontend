import 'package:flutter/material.dart';

import 'MarketPage.dart';
import 'SignInPage.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    final idTextEditController = TextEditingController();
    final pwTextEditController = TextEditingController();

    return Scaffold(
        backgroundColor: ourColor,
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('BIT',
                  style: TextStyle(
                      fontSize: 100,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const Text('우리학교 비대면 중고책 거래 마켓\n',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(labelText: '아이디'),
                      controller: idTextEditController,
                    ),
                  ),
                  const SizedBox(
                    width: 170,
                    child: Text(' @gm.hannam.ac.kr',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              TextField(
                decoration: const InputDecoration(labelText: '비밀번호'),
                controller: pwTextEditController,
              ),
              Row(
                children: [
                  const Text("계정이 없으신가요?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: const Text("가입하기"))
                ],
              ),
              Row(
                children: [
                  Text(
                    '$errorMsg\n',
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  const Spacer()
                ],
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      var a = await callAPI_Login('/api/login', {
                        "email": '${idTextEditController.text}@gm.hannam.ac.kr',
                        "password": pwTextEditController.text
                      });
                      if (a == 200) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MarketPage()),
                        );
                      } else if (a == 401) {
                        setState(() {
                          errorMsg = '아이디 혹은 비밀번호가 올바르지 않습니다';
                        });
                      } else {
                        setState(() {
                          errorMsg = '네트워크에 연결할 수 없습니다';
                        });
                      }
                    },
                    child: const Text("로그인")),
              )
            ],
          ),
        ));
  }
}
