import 'dart:ui';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/books_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BooksListCard extends StatefulWidget {
  final BooksModal booksindex;
  const BooksListCard({Key? key, required this.booksindex}) : super(key: key);

  @override
  State<BooksListCard> createState() => _BooksListCardState();
}

class _BooksListCardState extends State<BooksListCard> {
  var updatedAtTime;
  int timeFormat = 0;
  @override
  void initState() {
    calTimeDifFun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        print('on tap card');
        Navigator.pushNamed(context, chapterroute,
            arguments: {'passBookModel': widget.booksindex}
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.book,
                size: 36,
                color: Colors.blue,
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booksindex.book_name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 16,
                            ),
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
              const Icon(
                Icons.chevron_right,
                size: 36,
                color: kTextColorLightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calTimeDifFun() {
    // DateTime a = widget.booksindex.updated_at;
    DateTime dt1 = DateTime.parse(widget.booksindex.updated_at.toString());
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
