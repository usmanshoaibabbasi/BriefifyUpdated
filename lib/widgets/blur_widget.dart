import 'dart:ui';

import 'package:briefify/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget blurBackGroundWithContainer({
  context,
  passcontroller,
  passontapButton,
  passontapXmark,
  addheadertext,
  buttontext,
  passwidget
}) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20),
          ),
        ),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: passontapXmark,
                    child: Container(
                        margin: const EdgeInsets.only(top: 15,right: 8),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xffEDF0F4),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.xmark ,
                          color: kSecondaryTextColor,
                          size: 24,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  addheadertext,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              passwidget,
              const SizedBox(height: 20,),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: passcontroller,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.bottom,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Color(0xffEEEEEE),
                        )),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Color(0xffEEEEEE),
                        )),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Color(0xffEEEEEE),
                        )),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffEEEEEE),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    fillColor: Colors.white,
                    filled: true,
                    labelStyle: const TextStyle(
                      color: Color(0xffEEEEEE),
                      height: 2,
                    ),
                    label: Text(
                      buttontext,
                      style: TextStyle(
                          color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: passontapButton,
                      child: Text(
                        buttontext,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    ),
  );
}