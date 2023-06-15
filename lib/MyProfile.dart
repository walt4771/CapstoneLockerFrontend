import 'dart:convert';

import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'main.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  _MyProfileState createState() => _MyProfileState();
}

var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w300);

Future<dynamic> getProfile() async {
  return await json.decode((await getAPI_Auth('/api/myinfo'))[1]);
}

Widget profileCard(String contentName, String createDate) {
  double? cardWidth = 250;
  double? cardHeight = 120;

  return Container(
      decoration: BoxDecoration(
          color: ourColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          )),
      margin: const EdgeInsets.all(15),
      width: cardWidth,
      height: cardHeight,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contentName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              createDate.split('T')[0],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ));
}

Widget emptyProfile = const Center(
  child: Text(
    '목록이 비어 있습니다',
    style: TextStyle(
        color: Colors.black38
    ),
  ),
);

Widget categoryTitle(String title){
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Text(
      title,
    ),
  );
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: FutureBuilder(
                future: getProfile(),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 내정보
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                decoration:
                                BoxDecoration(shape: BoxShape.circle, color: ourColor),
                                margin: const EdgeInsets.all(10),
                                width: 60,
                                height: 60,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data['myinfo']['studentId'].toString(),
                                    style: titleStyle,
                                  ),
                                  Text(
                                    '내 포인트 ${snapshot.data['myinfo']['point']}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    deleteAuth();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                    );
                                  },
                                  child: const Text('로그아웃'))
                            ],
                          ),
                        ),



                        const Divider(thickness: 1, height: 10),

                        categoryTitle('판매가 완료된 책'),
                        SizedBox(
                          height: 120,
                          child: (snapshot.data['sold'] as List).isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      (snapshot.data['sold'] as List).length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          profileCard(
                                              snapshot.data['sold'][index]
                                                      ['saleProductName']
                                                  .toString(),
                                              snapshot.data['sold'][index]
                                                      ['createDate']
                                                  .toString()),
                                )
                              : emptyProfile,
                        ),

                        const Divider(thickness: 1, height: 10),

                        categoryTitle('내가 등록한 책'),
                        SizedBox(
                          height: 120,
                          child: (snapshot.data['raised'] as List).isNotEmpty
                              ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            (snapshot.data['raised'] as List).length,
                            itemBuilder:
                                (BuildContext context, int index) =>
                                profileCard(
                                    snapshot.data['raised'][index]
                                    ['saleProductName']
                                        .toString(),
                                    snapshot.data['raised'][index]
                                    ['createDate']
                                        .toString()),
                          )
                              : emptyProfile,
                        ),

                        const Divider(thickness: 1, height: 10),

                        categoryTitle('내가 구매한 책'),
                        SizedBox(
                          height: 120,
                          child: (snapshot.data['purchase'] as List).isNotEmpty
                              ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            (snapshot.data['purchase'] as List).length,
                            itemBuilder:
                                (BuildContext context, int index) =>
                                profileCard(
                                    snapshot.data['purchase'][index]
                                    ['saleProductName']
                                        .toString(),
                                    snapshot.data['purchase'][index]
                                    ['createDate']
                                        .toString()),
                          )
                              : emptyProfile,
                        ),
                      ],
                    );
                  }
                }))
      ],
    );
  }
}
