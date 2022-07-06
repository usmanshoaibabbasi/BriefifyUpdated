import 'dart:ui';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/pdfgenerator_screen.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/blur_widget.dart';
import 'package:briefify/widgets/books_card.dart';
import 'package:briefify/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:briefify/data/urls.dart';
import 'package:dio/dio.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}
final TextEditingController _addbookController = TextEditingController();

class _BooksScreenState extends State<BooksScreen> {
  late List<BooksModal> bookslist = [];
  late Future booksfuture;
  bool _addbook = false;
  ScrollController scrollController = ScrollController();
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    booksfuture = booksapifunction();
    // bookslist = booksapifunction();
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    /// User Provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;
    ///
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEDF0F4),
          bottomSheet: bottomportion(
            context: context,
            ///
            ontaphome: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, homeRoute, ModalRoute.withName(welcomeRoute));
            },
            ///
            homepasscolor: kTextColorLightGrey,
            ///
            ontapart: () {
              Navigator.pushNamedAndRemoveUntil(context, artfragment, ModalRoute.withName(welcomeRoute));
            },
            ///
            artpasscolor: kTextColorLightGrey,
            ///
            ontapcreatepost: () {
              if (_user.badgeStatus == badgeVerificationApproved) {
                Navigator.pushNamed(context, createPostRoute);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Text(
                            'You need to verify your profile before posting context'),
                        title: const Text('Verification Required'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Start'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(
                                  context, profileVerificationRoute);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            ///
            ontapbooks: () {
              ///
            },
            ///
            bookspasscolor:  kPrimaryColorLight,
            ontapprofile: () {
              Navigator.pushNamed(context, drawer);
            },
            ///
            passimagesource: _user.image,
          ),
        body: Stack(
          children: [
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 1st container having header portion
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          /// Icons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const ExtraScreen()),
                                  // );
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColorLight,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_outlined,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                          /// sizedbox after icons row
                          const SizedBox(height: 25,),
                          /// Recent Books row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Books',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _addbook = true;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColorLight,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.plus,
                                      color: Colors.white,
                                      size: 24,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    /// sizedbox after header
                    const SizedBox(height: 20,),
                    /// Books list portion
                    FutureBuilder(
                      future: booksfuture,
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null || snapshot.data.isEmpty) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 20.0),
                              child:  Center(
                                  child: Container(
                                    child: const Text('No Book Found',
                                      style: TextStyle(
                                          color: basiccolor,
                                          fontSize: 16
                                      ),
                                    ),
                                  )));
                        } else {
                          return
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                controller: scrollController,
                                itemCount: bookslist.length,
                                separatorBuilder: (context, index) => const SizedBox(
                                    height: 15,),
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return BooksListCard(
                                    booksindex: bookslist[index],
                                  );
                                }),
                            );
                        }
                     },
                    ),
                  ],
                ),
                _addbook == true ? blurBackGroundWithContainer(
                  context: context,
                  addheadertext: 'Add New Book',
                  buttontext: 'Add Book',
                  passcontroller: _addbookController,
                  passwidget: Container(),
                  passontapXmark: () {
                    setState(() {
                      _addbook = false;
                    });
                  },
                  passontapButton: () {
                    if (validData()) {
                      addbookfunction(
                        _addbookController.text,
                      );
                    }
                  },
                ): Container(),

              ],
            ),
            Column(
              children: [
                Expanded(
                  child: _loading == true ? const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: kPrimaryColorLight,
                    ),
                  ): Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Valid Data Function
  bool validData() {
    if (_addbookController.text.trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Enter valid book name');
      return false;
    }
    return true;
  }

  Future<String> addbookfunction (String bookName) async {
    setState(() {
      _loading = true;
    });
    final String apiToken = await Prefs().getApiToken();
    // const String apiToken =
    //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    var formData = FormData.fromMap({
      'book_name': bookName,
    });
    Dio dio = Dio();
    Response responce;
    try {
      responce = await dio.post(
        uAddBook,
        options: Options(headers: {
          "Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      if (responce.data['error'] == false) {
        var res1 = responce.data['error_data'];
        setState(() {
          _addbookController.clear();
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: res1);
          Navigator.pushReplacementNamed(context, booksroute);
        });
      }
    } catch (e) {
      if(kDebugMode) {
        print(e);
      }
      return 'some thing wrong';
    }
    setState(() {
      _loading = false;
    });
    return 'some thing wrong';
  }

  /// StaticList Function
  // List<BooksModal> booksapifunction() {
  //   List<BooksModal> booksstaticlistadd = <BooksModal>[];
  //
  //   booksstaticlistadd.add(BooksModal(
  //     id: 1,
  //     booktype: 'Computer Science',
  //     lastedited: 'Last edited 1 min ago',
  //   ));
  //   booksstaticlistadd.add(BooksModal(
  //     id: 2,
  //     booktype: 'Physics',
  //     lastedited: 'Last edited 1 min ago',
  //   ));
  //   booksstaticlistadd.add(BooksModal(
  //     id: 3,
  //     booktype: 'Chemistry',
  //     lastedited: 'Last edited 1 min ago',
  //   ));
  //   booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));booksstaticlistadd.add(BooksModal(
  //     id: 4,
  //     booktype: 'Communication Skill',
  //     lastedited: 'Last edited 1 min ago',
  //   ));
  //
  //
  //   return booksstaticlistadd;
  // }
  /// StaticList Function
  Future<List<BooksModal>> booksapifunction() async {
    setState(() {
      _loading = true;
    });
    final String apiToken = await Prefs().getApiToken();
     // const String apiToken =
     //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    Response sr;
    Dio dio = Dio();
    try {
      sr = await dio.post(uBooksUser,
          options: Options(headers: {"Authorization": "Bearer $apiToken"}));
      var resp = jsonDecode(jsonEncode(sr.data).toString());
      var response = resp['books'];


      for (var r in response) {
        BooksModal bookadd = BooksModal(
          id: r['id'] ?? 0,
          created_at: r['created_at'] ?? '',
          updated_at: r['updated_at'] ?? '',
          book_name: r['book_name'] ?? '',
          user_id: r['user_id'] ?? '',
          chapters: r['chapters'] ?? [],
        );
        bookslist.add(bookadd);
      }



      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
    return bookslist;
  }
}
