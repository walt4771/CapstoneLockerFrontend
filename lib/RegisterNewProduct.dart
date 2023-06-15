import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joongnaapp/MarketPage.dart';

import 'LoginPage.dart';
import 'main.dart';

import 'package:http/http.dart' as http;

class RegisterNewProduct extends StatefulWidget {
  const RegisterNewProduct({super.key});

  @override
  State<RegisterNewProduct> createState() => _RegisterNewProductState();
}

class _RegisterNewProductState extends State<RegisterNewProduct> {
  PickedFile? _image;

  bool isSubmitButtonClicked = false;

  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final saleProductNameTextController = TextEditingController();
  final amountTextController = TextEditingController(); // 가격(price)임

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('\n'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('판매글 작성',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () async {
                    if(!isSubmitButtonClicked){
                      isSubmitButtonClicked = true;
                      var url = Uri.parse('https://api.imgur.com/3/image');
                      var response = await http.post(url,
                          headers: <String, String>{
                            'Authorization': "Client-ID 9d22d3f1afd147d",
                            'Content-Type': 'application/json',
                          },
                          body: File(_image!.path).readAsBytesSync());

                      var res = json.decode(response.body);
                      // print(res['data']['link']);

                      var a = await callAPI_Auth('/api/saleproduct/create', {
                        "content": contentTextController.text,
                        "saleProductName": titleTextController.text,
                        "imgUrl": res['data']['link'],
                        "amount": amountTextController.text
                      });
                      if(a[0] == 200) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MarketPage()),
                        );
                      }else{
                        deleteAuth();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      }
                    }
                  },
                  child: const Text('등록하기'),
              )
            ],
          ),
          const Text('\n'),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  var image = await ImagePicker.platform
                      .pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                },
                child: Container(
                    color: ourColor,
                    width: 100,
                    height: 100,
                    child: _image == null
                        ? const Icon(Icons.camera_alt_outlined)
                        : Image.file(File(_image!.path))),
              )
            ],
          ),
          const Text('\n'),
          TextField(
              controller: titleTextController,
              decoration: const InputDecoration(labelText: '책 제목을 입력하세요')
          ),
          TextField(
              controller: amountTextController,
              decoration: const InputDecoration(labelText: '가격')),
          TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              controller: contentTextController,
              decoration: const InputDecoration(labelText: '내용')),
        ],
      ),
    ));
  }
}
