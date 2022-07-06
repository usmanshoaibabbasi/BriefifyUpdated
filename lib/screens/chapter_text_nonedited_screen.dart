import 'dart:convert';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:briefify/screens/pdfgenerator_screen.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

class ChapterTextNonEditedScreen extends StatefulWidget {
  final ChapterModal chapterModal;
  const ChapterTextNonEditedScreen({Key? key, required this.chapterModal}) : super(key: key);

  @override
  State<ChapterTextNonEditedScreen> createState() => _ChapterTextNonEditedScreenState();
}
//final TextEditingController _chaptertextController = TextEditingController();
quil.QuillController _chaptertextController = quil.QuillController.basic();
bool _loading = false;
class _ChapterTextNonEditedScreenState extends State<ChapterTextNonEditedScreen> {
  var selectedColor = 0;

  bool isDirty = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  @override
  void initState() {
    // _chaptertextController.text = widget.chapterModal.chapterstext == null ?
    // '' : widget.chapterModal.chapterstext.toString();
    // print(widget.chapterModal.chapterstext);
    // print(widget.chapterModal.chapterstext);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.chapterModal.chapterstext != null) {
      var myJSON = jsonDecode(widget.chapterModal.chapterstext.toString());
      _chaptertextController = quil.QuillController(
        document: quil.Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    // var a = "[{\"insert\":\"Kurulus osman season 3 episode 84 trailor in urdu hd maki\",\"attributes\":{\"underline\":true,\"color\":\"#ef9a9a\"}},{\"insert\":\"  hhhhhh is a great place to call home to \"},{\"insert\":\"the database the web 3.0 will use the decentralized mechanism such as in in use by the blockchain the famous decentralized framework currently used by most popular cryptocurrencies and the \",\"attributes\":{\"bold\":true}},{\"insert\":\"\\n\"}]";

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child:
                  widget.chapterModal.chapterstext == null ?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
                    child: TextField(
                      focusNode: contentFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      enabled: false,
                      // onChanged: (value) {
                      //   markContentAsDirty(value);
                      // },
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Edit your text to start typing...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ):
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
                    child: quil.QuillEditor.basic(
                      controller: _chaptertextController,
                      readOnly: true,
                    ),
                  ),
                ///
                // TextField(
                //   focusNode: titleFocus,
                //   autofocus: true,
                //   controller: titleController,
                //   keyboardType: TextInputType.multiline,
                //   maxLines: null,
                //   onSubmitted: (text) {
                //     titleFocus.unfocus();
                //     FocusScope.of(context).requestFocus(contentFocus);
                //   },
                //   textInputAction: TextInputAction.next,
                //   style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 30,
                //       fontWeight: FontWeight.w700),
                //   decoration: InputDecoration.collapsed(
                //     hintText: 'Enter a title',
                //     hintStyle: TextStyle(
                //         color: Colors.grey.shade400,
                //         fontSize: 30,
                //         fontFamily: 'Poppins',
                //         fontWeight: FontWeight.w700),
                //     border: InputBorder.none,
                //   ),
                // ),
                ///
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 3, 6, 3),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if(validData(false)) {
                                  if(kDebugMode) {
                                    print('valid data go to pdf gener');
                                  }
                                  // final pdfFile = await PdfApi.generatepdf(_chaptertextController.document.toPlainText().trim());
                                  // PdfApi.openFile(pdfFile);
                                  DateTime datetime = DateTime.now();
                                  final pdfFile = await PdfParagraphApi.generatepdf(
                                    _chaptertextController.document.toPlainText().trim(),
                                    widget.chapterModal.chapter_name,
                                    datetime,
                                  );
                                  PdfApi.openFile(pdfFile);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 3, right: 3),
                                child: const Icon(
                                  Icons.picture_as_pdf_sharp,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            GestureDetector(
                              onTap: () {
                                if(validData(true)) {
                                  deletechaptertext();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 3, right: 3),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            GestureDetector(
                              onTap: () {
                                // if(kDebugMode) {
                                //   print(widget.chapterModal.chapterstext.toString());
                                //   print(widget.chapterModal.id.toString());
                                // }
                                ///
                                // String passtext = '';
                                // if(widget.chapterModal.chapterstext == null) {
                                //   passtext = '';
                                // } else if(widget.chapterModal.chapterstext != null) {
                                //   passtext = widget.chapterModal.chapterstext;
                                // }
                                ///
                                Navigator.pushNamed(context, chapterTextroute,
                                    arguments: {
                                  'passChapterText': widget.chapterModal.chapterstext,
                                   'passChapterId': widget.chapterModal.id,
                                }
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 3,right: 3),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),),
                      ///
                      ///

                    ],
                  ),
                ),
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
  bool validData(bool action) {
    if (_chaptertextController.document.toPlainText().trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: action == true ? 'No text found to delete' : 'No text found to Generate pdf');
      return false;
    }
    return true;
  }
  Future<String> deletechaptertext () async {
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
      'chapter_id': widget.chapterModal.id.toString(),
      'text': '',
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
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: 'Chapter deleted');
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
