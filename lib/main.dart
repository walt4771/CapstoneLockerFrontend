import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:joongnaapp/LoginPage.dart';

var ourColor = const Color.fromRGBO(112, 185, 136, 1);

var host = 'http://<IP ADDR>:<PORT>';

void main() {
  runApp(const MyApp());
}

Future<List<dynamic>> getAPI_Auth(String api) async {
  const secureStorage = FlutterSecureStorage();

  var url = Uri.parse(host + api);
  String key = await secureStorage.read(key: 'login') as String;

  var response = await http.get(url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': key
    },
  );

  // print('res stat(auth): ${response.statusCode}');
  // print('res body(auth): ${response.body}');

  return [response.statusCode, utf8.decode(response.bodyBytes)];
}

Future<String> getAPI(String api) async {
  var url = Uri.parse(host + api);
  var response = await http.get(url);

  // print('res stat: ${response.statusCode}');
  // print('res body: ${response.body}');

  return utf8.decode(response.bodyBytes);
}

Future<int> callAPI(String api, Map<String, String> body) async {
  var url = Uri.parse(host + api);
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body));

  // print('res stat: ${response.statusCode}');
  // print('res body: ${response.body}');

  return response.statusCode;
}


Future<int> callAPI_Login(String api, Map<String, String> body) async {
  const secureStorage = FlutterSecureStorage();
  var url = Uri.parse(host + api);
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body));

  // print('res stat: ${response.statusCode}');
  // print('res body: ${response.headers['authorization']}');

  secureStorage.write(key: 'login', value: response.headers['authorization']);
  return response.statusCode;
}

bool deleteAuth() {
  const secureStorage = FlutterSecureStorage();
  secureStorage.delete(key: 'login');

  return true;
}

Future<bool> asyncDummy() async {
  return await true;
}

Future<List<dynamic>> callAPI_Auth(String api, Map<String, String> body) async {
  const secureStorage = FlutterSecureStorage();

  var url = Uri.parse(host + api);
  if(await secureStorage.read(key: 'login') == null){
    // print(await secureStorage.read(key: 'login'));
    return [401, []];
  }
  String key = await secureStorage.read(key: 'login') as String;
  // var key = secureStorage.read(key: 'login').toString(); Difference??

  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': key
      },
      body: jsonEncode(body));

  // print('res stat(auth): ${response.statusCode}');
  // print('res body(auth): ${response.body}');

  return [response.statusCode, utf8.decode(response.bodyBytes)];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MarketPage(),
//     );
//   }
// }

// LoginPage

// SignInPage

// SignInInfoPage

// ProductListPage

// MarketPage

// ProductDetailPage

// RegisterNewProduct