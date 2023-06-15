import 'package:flutter/material.dart';
import 'package:joongnaapp/MyProfile.dart';
import 'package:joongnaapp/ProductList.dart';

import 'RegisterNewProduct.dart';
import 'main.dart';

var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w300);

Widget meow() {
  AnimationController ac;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text('BIT',
            style: TextStyle(
                fontSize: 100,
                color: Color.fromRGBO(112, 185, 136, 1),
                fontWeight: FontWeight.bold)),
        Text('우리학교 비대면 중고책 거래 마켓\n',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(112, 185, 136, 1),
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    const ProductList(),
    meow(),
    const MyProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterNewProduct()),
          );
        },
        label: const Text(
          '판매글 쓰기',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.edit),
        backgroundColor: ourColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: '상품 리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'BIT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
