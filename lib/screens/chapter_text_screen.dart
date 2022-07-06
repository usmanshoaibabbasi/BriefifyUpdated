import 'dart:convert';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChapterTextScreen extends StatefulWidget {
  var passChapterText;
  final int passChapterId;
  ChapterTextScreen({Key? key, required this.passChapterText, required this.passChapterId}) : super(key: key);

  @override
  State<ChapterTextScreen> createState() => _ChapterTextScreenState();
}

// final TextEditingController _chaptertextController = TextEditingController();
 quil.QuillController _chaptertextController = quil.QuillController.basic();
bool _loading = false;
class _ChapterTextScreenState extends State<ChapterTextScreen> {
  ScrollController _scrollController = ScrollController();
  var selectedColor = 0;

  @override
  void initState() {
    // TODO: implement initState
    if(kDebugMode) {
      print('Chapter Text Screen');
      print(widget.passChapterText);
      print('Chapter Text Screen');
    }
    // _chaptertextController.text = widget.passChapterText.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var a = "[{\"insert\":\"Kurulus osman season 3 episode 84 trailor in urdu hd maki\",\"attributes\":{\"underline\":true,\"color\":\"#ef9a9a\"}},{\"insert\":\"  hhhhhh is a great place to call home to \"},{\"insert\":\"the database the web 3.0 will use the decentralized mechanism such as in in use by the blockchain the famous decentralized framework currently used by most popular cryptocurrencies and the \",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"}]";
    var myJSON;
    if(widget.passChapterText != null) {
      myJSON = jsonDecode(widget.passChapterText.toString());
    } else {
      var staticJSON = "[{\"insert\":\"Start Writing Your text\"},{\"insert\":\"\\n\"}]";
      myJSON = jsonDecode(staticJSON.toString());
    }
      _chaptertextController = quil.QuillController(
        document: quil.Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: kPrimaryColorLight,
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                      Row(
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //   },
                          //   child: Container(
                          //     padding: const EdgeInsets.only(left: 3, right: 3),
                          //     child: const Icon(
                          //       FontAwesomeIcons.eraser,
                          //       color: Colors.blue,
                          //       size: 30,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () {
                              savechaptertext();
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 3, 6, 3),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    'SAVE',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),),
                          ),
                        ],
                      ),
                      ///
                      ///

                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                quil.QuillToolbar.basic(
                  controller: _chaptertextController,
                  showImageButton: false,
                  showVideoButton: false,
                  showCameraButton: false,
                  // showHistory: false,
                  // Todo Here i have made changes for Error
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 16, 0),
                    child: Container(
                      child: quil.QuillEditor.basic(
                        controller: _chaptertextController,
                        readOnly: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // SingleChildScrollView(
            //   child: Padding(
            //     padding: const EdgeInsets.all(0.0),
            //     child: Padding(
            //       padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
            //       child:
            //       TextField(
            //         focusNode: contentFocus,
            //         controller: _chaptertextController,
            //         keyboardType: TextInputType.multiline,
            //         maxLines: null,
            //         // onChanged: (value) {
            //         //   markContentAsDirty(value);
            //         // },
            //         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            //         decoration: InputDecoration.collapsed(
            //           hintText: 'Start typing...',
            //           hintStyle: TextStyle(
            //               color: Colors.grey.shade400,
            //               fontSize: 16,
            //               fontWeight: FontWeight.w500),
            //           border: InputBorder.none,
            //         ),
            //       ),
            //     )
            //         ///
            //     // TextField(
            //     //   focusNode: titleFocus,
            //     //   autofocus: true,
            //     //   controller: titleController,
            //     //   keyboardType: TextInputType.multiline,
            //     //   maxLines: null,
            //     //   onSubmitted: (text) {
            //     //     titleFocus.unfocus();
            //     //     FocusScope.of(context).requestFocus(contentFocus);
            //     //   },
            //     //   textInputAction: TextInputAction.next,
            //     //   style: TextStyle(
            //     //       fontFamily: 'Poppins',
            //     //       fontSize: 30,
            //     //       fontWeight: FontWeight.w700),
            //     //   decoration: InputDecoration.collapsed(
            //     //     hintText: 'Enter a title',
            //     //     hintStyle: TextStyle(
            //     //         color: Colors.grey.shade400,
            //     //         fontSize: 30,
            //     //         fontFamily: 'Poppins',
            //     //         fontWeight: FontWeight.w700),
            //     //     border: InputBorder.none,
            //     //   ),
            //     // ),
            //     ///
            //   ),
            // ),
            Column(
              children: [
                Expanded(
                  child: _loading == true ? const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: kPrimaryColorLight,
                    ),
                  ): Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  bool validData() {
    if (_chaptertextController.document.toPlainText().trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Chapter can not have empty text');
      return false;
    }
    return true;
  }
  Future<String> savechaptertext () async {
    setState(() {
      _loading = true;
    });
    final String apiToken = await Prefs().getApiToken();
    if(kDebugMode) {
      // print('Enter In Function');
      // print(apiToken);
      // print(widget.passChapterId.toString());
    }
    // const String apiToken =
    //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    var formData = FormData.fromMap({
      'chapter_id': widget.passChapterId.toString(),
      'text': jsonEncode(_chaptertextController.document.toDelta().toJson()),
    });
    Dio dio = Dio();
    Response responce;
    try {
      // print('Enter In Try');
      responce = await dio.post(
        uUpdateChapterText,
        options: Options(headers: {
          "Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      if (responce.data['error'] == false) {

        var res1 = responce.data['error_data'];
        setState(() {
          // _chaptertextController.text = '';
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: res1);
          Navigator.pushNamedAndRemoveUntil(context, booksroute,(route) => false);
        });
      }
    } catch (e) {
      print(e);
      return 'some thing wrong';
    }
    setState(() {
      _loading = false;
    });
    return 'some thing wrong';
  }
}
