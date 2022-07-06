import 'dart:ui';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:briefify/providers/books_chapters_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChapterListCard extends StatefulWidget {
  final ChapterModal chapterindex;
  final bookName;
  final indexnumber;
  const ChapterListCard({Key? key,
    required this.chapterindex,
    required this.bookName,
    required this.indexnumber,
  }) : super(key: key);

  @override
  State<ChapterListCard> createState() => _ChapterListCardState();
}

class _ChapterListCardState extends State<ChapterListCard> {
  var updatedAtTime;
  int timeFormat = 0;
  @override
  void initState() {
    calTimeDifFun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final booksChapterProvider = Provider.of<BooksChapterProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 12, 3, 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                booksChapterProvider.selectchapter(widget.indexnumber);
              },
              child:  Consumer<BooksChapterProvider>(
                  builder: (context, value, child) {
                    return Icon(
                      value.intlist_provider[widget.indexnumber] == 0 ?
                      CupertinoIcons.check_mark_circled:
                      CupertinoIcons.check_mark_circled_solid,
                      size: 30,
                      color: value.intlist_provider[widget.indexnumber] == 0 ? Colors.grey : Colors.blue,
                    );
                  }
              ),
            ),
            const SizedBox(width: 10,),
            const Icon(
              CupertinoIcons.book,
              size: 36,
              color: Colors.blue,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // if(kDebugMode) {
                  //   print('on tap chapter card');
                  // }
                  Navigator.pushNamed(context, chapterTextNonEditedroute,
                      arguments: {'passChapterModel': widget.chapterindex}
                  );
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.bookName} | ${widget.chapterindex.chapter_name}',
                                style: const TextStyle(
                                  color: kSecondaryTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3,),
                          Row(
                            children: [
                              Text(
                                updatedAtTime.toString(),
                                style: const TextStyle(
                                  color: kSecondaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                timeFormat == 0 ? ' sec ago': timeFormat == 1 ? ' min ago' : timeFormat == 2 ? ' Hour ago' : ' Days ago',
                                style: const TextStyle(
                                  color: kSecondaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // if(kDebugMode) {
                //   print('on tap chapter card');
                // }
                Navigator.pushNamed(context, chapterTextNonEditedroute,
                    arguments: {'passChapterModel': widget.chapterindex}
                );
              },
              child: const Icon(
                Icons.chevron_right,
                size: 36,
                color: kTextColorLightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calTimeDifFun() {
    // DateTime a = widget.booksindex.updated_at;
    DateTime dt1 = DateTime.parse(widget.chapterindex.updated_at.toString());
    // print(dt1);
    DateTime dt2 = DateTime.now();
    Duration diff = dt2.difference(dt1);
    updatedAtTime = diff.inSeconds;
    // print('inSeconds');
    // print(updatedAtTime);
    if(updatedAtTime>60 && timeFormat == 0) {
      updatedAtTime = diff.inMinutes;
      timeFormat = 1;
      // print(updatedAtTime);
      // print('inMinutes');
    }
    if(updatedAtTime>60 && timeFormat == 1) {
      updatedAtTime = diff.inHours;
      timeFormat = 2;
      // print(updatedAtTime);
      // print('inHours');
    }
    if(updatedAtTime>24 && timeFormat == 2) {
      updatedAtTime = diff.inDays;
      timeFormat = 3;
      // print(updatedAtTime);
      // print('inDays');
    }

    // print('difference endddddddddddddddddddddddddddddddddd');
    // final now = DateTime.now();
    // print(null);
    // var difference = now.difference(a).inSeconds;
    // print(difference);
  }
}