import 'dart:convert';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:briefify/providers/books_chapters_provider.dart';
import 'package:briefify/screens/pdfgenerator_screen.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/blur_widget.dart';
import 'package:briefify/widgets/chapter_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:briefify/data/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:briefify/data/urls.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

class ChapterScreen extends StatefulWidget {
  final BooksModal BookModel;
  const ChapterScreen({Key? key,required this.BookModel,}) : super(key: key);

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}


class _ChapterScreenState extends State<ChapterScreen> {
  late List<ChapterModal> chapterlist = [];
  late Future chapterfuture;
  bool _achapter = false;
  ScrollController scrollController = ScrollController();
  bool _loading = false;
  final TextEditingController _addchapterController = TextEditingController();
  @override
  void initState() {
    if(kDebugMode) {
      print(widget.BookModel.chapters.toString());
      print(widget.BookModel.chapters.length.toString());
    }
    chapterfuture = chaptersapifunction();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final booksChapterProvider = Provider.of<BooksChapterProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEDF0F4),
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
                                  Navigator.pop(context);
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
                                      size: 24,
                                    )),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  int indextoadd = 0;
                                  DateTime datetime = DateTime.now();
                                  var pdfFile;
                                  var myJSON;
                                  var chaptertextpass;
                                  var chaptext;
                                  var chapname;
                                  String spaces = '                                      ';
                                  sortwhichitems().then((value) => {
                                  for(int i=0; i<booksChapterProvider.whichChapters_list.length; i++) {
                                    indextoadd= booksChapterProvider.whichChapters_list[i],
                                      ///
                                  myJSON = jsonDecode(chapterlist[indextoadd].chapterstext.toString()),
                                    chaptext = quil.QuillController(
                                  document: quil.Document.fromJson(myJSON),
                                  selection: const TextSelection.collapsed(offset: 0),
                                  ),
                                    chaptext = chaptext.document.toPlainText().trim(),
                                    chapname = chapterlist[indextoadd].chapter_name.toString(),
                                    if(chaptertextpass != null) {
                                      chaptertextpass = '$chaptertextpass $chapname\n\n   $chaptext\n\n\n',
                                    } else
                                      {
                                        chaptertextpass = '$chapname \n\n   $chaptext $spaces\n\n\n',
                                      }

                                  },
                                  }).then((value) async => {
                                      pdfFile = await PdfParagraphApiMultiChapter.generatepdf(
                                      chaptertextpass,
                                      widget.BookModel.book_name.toString(),
                                      datetime,
                                  ),
                                  PdfApi.openFile(pdfFile),
                                  });
                                },
                                child: Consumer<BooksChapterProvider>(
                                  builder: (context, value, child) {
                                    return value.selectedchapters == 1 ? const Icon(
                                      Icons.picture_as_pdf_sharp,
                                      color: Colors.blue,
                                      size: 35,
                                    ): Container();
                                  }
                                ),
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
                                'Recent Chapter',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _achapter = true;
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
                      future: chapterfuture,
                      builder:
                          (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null || snapshot.data.isEmpty) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 20.0),
                              child:  Center(
                                  child: Container(
                                    child: const Text('No Chapter Found',
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
                                  itemCount: chapterlist.length,
                                  separatorBuilder: (context, index) => const SizedBox(
                                    height: 15,),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ChapterListCard(
                                      chapterindex: chapterlist[index],
                                      bookName: widget.BookModel.book_name.toString(),
                                        indexnumber: index
                                    );
                                  }),
                            );
                        }
                      },
                    ),
                  ],
                ),
                _achapter == true ? blurBackGroundWithContainer(
                  context: context,
                  passcontroller: _addchapterController,
                  addheadertext: 'Add New Chapter',
                  buttontext: 'Add Chapter',
                  passwidget:
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 15),
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.2),
                  //         spreadRadius: 3,
                  //         blurRadius: 7,
                  //         offset: const Offset(0, 3), // changes position of shadow
                  //       ),
                  //
                  //     ],
                  //     borderRadius: const BorderRadius.all(Radius.circular(30)),
                  //
                  //   ),
                  //   child: TextFormField(
                  //     keyboardType: TextInputType.text,
                  //     textAlignVertical: TextAlignVertical.bottom,
                  //     textInputAction: TextInputAction.next,
                  //     enabled: false,
                  //     style: const TextStyle(
                  //       color: Colors.black,
                  //     ),
                  //     decoration: InputDecoration(
                  //       // contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                  //       fillColor: Colors.white,
                  //       filled: true,
                  //       labelStyle: const TextStyle(
                  //         color: Color(0xffEEEEEE),
                  //         height: 2,
                  //       ),
                  //       label: Text(
                  //         widget.BookModel.book_name.toString(),
                  //         style: TextStyle(
                  //             color: Colors.grey.shade400),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ///
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),

                          ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              widget.BookModel.book_name.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ///
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 15),
                  //   decoration: const BoxDecoration(
                  //   ),
                  //   child: Card(
                  //     child: Padding(
                  //         padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                  //       child: Row(
                  //         children: const [
                  //           Text('Add Chapter'),
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  // ),
                  passontapXmark: () {
                    setState(() {
                      _achapter = false;
                    });
                  },
                  passontapButton: () {
                    if (validData()) {
                      addchapterfunction(
                        _addchapterController.text,
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
            )
          ],
        ),
      ),
    );
  }
  bool validData() {
    if (_addchapterController.text.trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Enter valid Chapter name');
      return false;
    }
    return true;
  }
  /// StaticList Function
  Future<List<ChapterModal>> chaptersapifunction() async {
    setState(() {
      _loading = true;
    });
    final String apiToken = await Prefs().getApiToken();
    // const String apiToken =
    //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    var formData = FormData.fromMap({
      'book_id': widget.BookModel.id,
    });
    Response sr;
    Dio dio = Dio();
    try {
      sr = await dio.post(uChapterUser,
          options: Options(headers: {"Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      var resp = jsonDecode(jsonEncode(sr.data).toString());
      var response = resp['chapters'];


      for (var r in response) {
        ChapterModal wallet = ChapterModal(
          id: r['id'] ?? 0,
          created_at: r['created_at'] ?? '',
          updated_at: r['updated_at'] ?? '',
          chapter_name: r['chapter_name'] ?? '',
          user_id: r['user_id'] ?? '',
          book_id: r['book_id'] ?? '',
          chapterstext: r['text'],
        );
        chapterlist.add(wallet);
      }
      setState(() {
        final booksChapterProvider = Provider.of<BooksChapterProvider>(context, listen: false);
        booksChapterProvider.setChapterList(chapterlist);
        booksChapterProvider.setIntegerList(chapterlist);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // print(e);
    }
    return chapterlist;
  }
  ///
  Future<String> addchapterfunction (String chapterName) async {
    setState(() {
      _loading = true;
    });
    // final String apiToken = await Prefs().getApiToken();
    const String apiToken =
        'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    var formData = FormData.fromMap({
      'chapter_name': chapterName,
      'book_id': widget.BookModel.id.toString(),
    });
    Dio dio = Dio();
    Response responce;
    try {
      responce = await dio.post(
        uAddChapter,
        options: Options(headers: {
          "Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      if (responce.data['error'] == false) {

        var res1 = responce.data['error_data'];
        setState(() {
          _addchapterController.clear();
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: res1);
          Navigator.pushNamedAndRemoveUntil(context, booksroute,(route) => false);
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

  Future sortwhichitems() async {
    final booksChapterProvider = Provider.of<BooksChapterProvider>(context, listen: false);
    booksChapterProvider.checkWhichChapterSelected();
  }
}
