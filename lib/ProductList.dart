import 'dart:convert';

import 'package:flutter/material.dart';

import 'ProductDetailPage.dart';
import 'main.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w300);

Future<dynamic> getProductsAll() async {
  return await json.decode(await getAPI('/api/saleproduct/find/all'))['data'];
}

Future<dynamic> getSearchedProducts(String searchKeyword) async {
  return await json.decode(
      await getAPI('/api/saleproduct/search/?search=$searchKeyword'))['data'];
}

class _ProductListState extends State<ProductList> {
  final TextEditingController searchController = TextEditingController();
  bool _isSearch = false;
  String searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    hintText: '책 검색하기', border: InputBorder.none),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _isSearch = true;
                    searchKeyword = searchController.text;
                  });
                },
              )),
        ),
        Flexible(
            child: FutureBuilder(
                future: _isSearch
                    ? getSearchedProducts(searchKeyword)
                    : getProductsAll(),
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
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Flexible(
                                child: RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  _isSearch = false;
                                });
                              },
                              child: snapshot.data.length == 0
                                  ? ListView(
                                      children: const [
                                        Center(
                                          child: Text(
                                            '\n목록이 없습니다',
                                            style: TextStyle(
                                                color: Colors.black38),
                                          ),
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailPage(snapshot
                                                          .data[index]['id']
                                                          .toString())),
                                            );
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            alignment: Alignment.centerLeft,
                                            width: double.infinity - 100,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    // 사진 부분
                                                    margin: const EdgeInsets
                                                        .fromLTRB(4, 4, 10, 4),
                                                    width: 90,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2,
                                                            color: ourColor)),
                                                    child: Image.network(
                                                        snapshot.data[index]
                                                            ['imgUrl']),
                                                  ),
                                                  Column(
                                                    // 정보 부분
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          snapshot.data[index][
                                                                  'saleProductName']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      20)),
                                                      Text(
                                                          '${snapshot.data[index]['createDate'].split('T')[0]}',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize:
                                                                      14)),
                                                      Text(
                                                          '${snapshot.data[index]['amount'].toString()} 원',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color: ourColor)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                            ))
                          ],
                        ));
                  }
                }))
      ],
    );
  }
}
