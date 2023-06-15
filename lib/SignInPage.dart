import 'package:flutter/material.dart';
import 'package:joongnaapp/LoginPage.dart';

import 'SignInInfoPage.dart';
import 'main.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailTextController = TextEditingController();
  final authNumTextController = TextEditingController();
  int onRequestAuthNum = 0;

  Widget onMailAuthClicked() {
    if (onRequestAuthNum == 0) {
      return const Text("\n");
    } else {
      return TextField(
          controller: authNumTextController,
          decoration: const InputDecoration(labelText: '인증번호를 입력하세요'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ourColor,
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('한남대학교 학교 이메일 인증을 진행합니다\n',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                        controller: emailTextController,
                        decoration: const InputDecoration(labelText: '한남대학교 학번 입력')),
                  ),
                  const SizedBox(
                    width: 170,
                    child: Text(' @gm.hannam.ac.kr',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              onMailAuthClicked(),
              const Text("\n"),
              OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      onRequestAuthNum += 1;
                    });
                    if (onRequestAuthNum == 1) {
                      var a = await callAPI('/api/email/send/auth', {
                        "email": '${emailTextController.text}@gm.hannam.ac.kr'
                      });
                    } else if (onRequestAuthNum > 1) {
                      var a = await callAPI('/api/email/send/auth/check', {
                        "email": '${emailTextController.text}@gm.hannam.ac.kr',
                        "authCode": authNumTextController.text
                      });
                      if (a == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInInfoPage(
                                  '${emailTextController.text}@gm.hannam.ac.kr')),
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    }
                  },
                  child: Text(onRequestAuthNum == 0 ? '인증번호 받기' : '확인',
                      style: const TextStyle(fontSize: 15, color: Colors.white)))
            ],
          ),
        ));
  }
}
