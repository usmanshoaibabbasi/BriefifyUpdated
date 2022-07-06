import 'dart:io';
import 'dart:math';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class CreateArtScreen extends StatefulWidget {
  const CreateArtScreen({Key? key}) : super(key: key);

  @override
  State<CreateArtScreen> createState() => _CreateArtScreenState();
}

class _CreateArtScreenState extends State<CreateArtScreen> {
  XFile? _image;
  late XFile file;
  bool progress = false;
  int char = 0;
  var sizeoffile;
  late double size;
  late int sizeinkb;
  final TextEditingController _summaryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var totalheight = MediaQuery.of(context).size.height;
    var totalwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0XffEDF0F4),
          body: Stack(
            children: [
              Column(
                children: [
                  /// First Container
                  Container(
                    height: totalheight*0.13,
                    width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 10),
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
                  ),
                  /// SizedBox After First Container
                  SizedBox(height: totalheight*0.02,),
                  /// Second Container
                  Container(
                    width: totalwidth,
                    height: totalheight*0.25,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _summaryController,
                        decoration: kPostInputDecoration.copyWith(
                          labelText: 'Summary',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 10,
                        maxLength: 250,
                      ),
                    ),
                  ),
                  /// SizedBox After Second Container
                  SizedBox(height: totalheight*0.02,),
                  /// Third Container
                  Container(
                    width: totalwidth,
                    height: totalheight*0.49,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 20,),
                          height: totalheight*0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _image == null;
                                    Navigator.pushReplacementNamed(context, createArtRoute);

                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: _image != null
                                        ?
                                    kPrimaryColorLight
                                        :
                                    kTextColorLightGrey,
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  child: const Icon(FontAwesomeIcons.xmark,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            file = (await FilePickerHelper().getImage())!;
                            if (file != null) {
                              setState(() {
                                // print('size sssssssssssssss');
                                // if(sizeinkb > 1024) {
                                //   SnackBarHelper
                                //       .showSnackBarWithoutAction(
                                //       context,
                                //       message: 'Image size should be less than 1 mb');
                                // }
                                // else {
                                  var a = file.path.split('/').last.toString();
                                  var b = a.length;
                                  var c = a.substring(b-3,b-0);
                                  if (c == 'jpg' || c == 'png') {
                                    getFileSize(file.path, 1).then((value) =>
                                    {
                                    if(size>200) {
                                        compressfunc(file.path, 1,size)
                                  } else{
                                    print('no compress')
                                  }
                                    });
                                    _image = file;
                                    SnackBarHelper
                                        .showSnackBarWithoutAction(
                                        context,
                                        message: 'Image selected');
                                  } else {
                                    SnackBarHelper
                                        .showSnackBarWithoutAction(
                                        context,
                                        message:
                                        'Only jpg, and png accepted');
                                  }
                                //}

                              });
                            }
                          },
                          child: Container(
                            width: totalwidth,
                            height: totalheight*0.27,
                            margin: EdgeInsets.fromLTRB(10, totalheight*0.03, 10, totalheight*0.03),
                            decoration: const BoxDecoration(
                              color: Color(0xffFFFFFF),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: _image != null
                                ?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.fill,
                              ),
                            )
                                :
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Select Image',
                                  style: TextStyle(
                                    color: kTextColorLightGrey,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Icon(FontAwesomeIcons.camera,
                                size: 50,
                                color: kTextColorLightGrey,),
                              ],
                            ),
                          ),
                        ),
                        /// Forth Container
                        Container(
                          height: totalheight*0.07,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                _image == null
                                    ? Icons.check_circle_outline
                                    : Icons.check_circle,
                                color: _image == null
                                    ? kTextColorLightGrey
                                    : kPrimaryColorLight,
                              ),
                              ButtonOne(
                                title: 'Post',
                                onPressed: () {
                                  if (validData()) {
                                    createPost(
                                      _image,
                                      _summaryController.text,
                                    );
                                  }
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: totalheight*0.02,),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                  child: progress == true ?
                  const SpinKitCircle(
                    size: 50,
                    color: kPrimaryColorLight,
                  ):
                  Container(),
              ),
            ],
          ),
        )
    );
  }

  bool validData() {
    if (_image == null) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please select image');
      return false;
    }
    if (_summaryController.text.trim().length>250) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Max 250 characters are allowed');
      return false;
    }
    return true;
  }

  Future<String> createPost (var _image,String summary) async {
    setState(() {
      progress = true;
    });
    final String apiToken = await Prefs().getApiToken();
    String type = 1.toString();
    var filename = _image.path.split('/').last;
    var formData = FormData.fromMap({
      'art_image': await MultipartFile.fromFile(_image.path,
          filename: filename, contentType:
          MediaType('image', 'png')),
      'type': type,
      'heading': summary,
    });
    Dio dio = Dio();
    Response responce;
    try {
      responce = await dio.post(
        uCreateArt,
        options: Options(headers: {
          "Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      if (responce.data['error'] == false) {
        var res1 = responce.data['post'];
        setState(() {
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: 'Posted');
          _image == null;
          Navigator.pushReplacementNamed(context, createArtRoute);
        });
      }
    } catch (e) {
      print(e);
      return 'some thing wrong';
    }
    setState(() {
      progress = true;
    });
    return 'some thing wrong';
  }

  Future<dynamic>getFileSize(String filepath, int decimals) async {
    print('enter in getFileSize');
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) {
      return "0 B";
    }
    var i = (log(bytes) / log(1024)).floor();
    size = ((bytes / pow(1024, i)));
    print('File Size is here');
    print(size.toString());
    ///
    return ((bytes / pow(1024, i)));
  }

  Future<dynamic> compressfunc(var filecompress, int decimal, var size) async {
    print('enter in compress');
    double a =100 - (200 / size)*100;
    print('1111111--------200 / size');
    print(a.toString());
    // double aa = a*100;
    print('2222222222--------a*100');
    int b = a.round();
    print(b.toString());
    var percent = b.toStringAsFixed(0);
    print('3333333333333--------percent to compress');
    print(percent.toString());
    int percentage = int.parse(percent);
    filecompress = filecompress.toString();
    // print(filecompress);
    File compressedFile = await FlutterNativeImage.compressImage(filecompress,
        quality: 100, percentage: percentage);
    _image = XFile(compressedFile.path);
    ///
    int bytes = await compressedFile.length();
    if (bytes <= 0)
      return null;
    var i = (log(bytes) / log(1024)).floor();
    var compresssize = ((bytes / pow(1024, i)));
    print('compress Size is here');
    print(compresssize.toString());
    return compressedFile;
  }
}
