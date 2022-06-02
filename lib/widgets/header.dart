import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget headerPortion({
    context,
    ontapmenuicon,
    ontapsearch,
    ontaphome,
    homepasscolor,
    ontapart,
    artpasscolor,
    ontapbriefifylogo,
    ontapprofile,
    passimagesource,
    ontapcreatepost,
    passtextofcreatepost}) {
  return Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            /// 1st container
            Container(
              height: MediaQuery.of(context).size.width*0.15,
              // color: Colors.yellow,
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ontapmenuicon,
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Color(0xffBBBBBB),
                    ),
                  ),
                  Image.asset(
                    appLogo,
                    height: 23,
                    width: 75,
                  ),
                  GestureDetector(
                    onTap: ontapsearch,
                    child: const Icon(
                      Icons.search_sharp,
                      size: 30,
                      color: kPrimaryColorLight,
                    ),
                  )
                ],
              ),
            ),
            /// 2nd container
            Container(
              height: MediaQuery.of(context).size.width*0.10,
              // color: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ontaphome,
                    child: Icon(
                      FontAwesomeIcons.house,
                      color: homepasscolor,
                      size: 25,
                    ),
                  ),
                  GestureDetector(
                    onTap: ontapart,
                    child:  Icon(
                      FontAwesomeIcons.leaf,
                      color: artpasscolor,
                      size: 25,
                    ),
                  ),
                  GestureDetector(
                    onTap: ontapbriefifylogo,
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(25 / 360),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            launchericon,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            /// 3rd container
            Container(
              height: MediaQuery.of(context).size.width*0.05,
              // color: Colors.blue,
            ),
            /// 4th container
            Container(
              height: MediaQuery.of(context).size.width*0.15,
              // color: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: ontapprofile,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: FadeInImage(
                          placeholder: const AssetImage(userAvatar),
                          image: NetworkImage(passimagesource),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, object, trace) {
                            return Image.asset(
                              appLogo,
                              height: 30,
                              width: 30,
                            );
                          },
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: ontapcreatepost,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xffBBBBBB)),
                            color: const Color(0xffFFFFFF)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
                          child: Text(
                              passtextofcreatepost,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /// 5th container
            Container(
              height: MediaQuery.of(context).size.width*0.05,
              // color: Colors.indigo,
            ),
          ],
        ),
      ),
      Container(
        height: 15,
        color: const Color(0XffEDF0F4),
      )
    ],
  );
}