import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joongnaapp/MarketPage.dart';

import 'main.dart';

class ProductDetailPage extends StatefulWidget {
  String productId;

  ProductDetailPage(this.productId, {super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}



class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
            future: getAPI_Auth('/api/saleproduct/find/${widget.productId}'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
              if (snapshot.hasData == false) {
                return const CircularProgressIndicator();
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
              else {
                var data = json.decode(snapshot.data[1]);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: ourColor,
                      child: Image.network(data['data']['imgUrl']),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text('${data['data']['saleStudentId']}님의 게시글',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14))
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              getAPI_Auth(
                                  '/api/order/create/${widget.productId}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MarketPage())
                              ).then((value) => setState(() {}));
                            },
                            child: Text('구매하기',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: ourColor)),
                          )
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(data['data']['saleProductName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20)),
                          const Spacer(),
                          Text('${data['data']['amount']}원',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: ourColor)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text('\n${data['data']['content'].toString()} '),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
