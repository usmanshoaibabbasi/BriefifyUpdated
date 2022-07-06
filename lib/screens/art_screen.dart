import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/fragments/art_fragment.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/widgets/header.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtScreen extends StatefulWidget {
  const ArtScreen({Key? key}) : super(key: key);

  @override
  State<ArtScreen> createState() => _ArtScreenState();
}

class _ArtScreenState extends State<ArtScreen> {
  @override
  Widget build(BuildContext context) {
    /// global key
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    ///
    /// user provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;
    return SafeArea(
      child: Scaffold(
              extendBody: true,
              body: const ArtFragment(),
        bottomSheet: bottomportion(
          context: context,
          ///
          ontaphome: () {
            Navigator.pushNamedAndRemoveUntil(
                context, homeRoute, ModalRoute.withName(welcomeRoute));
          },
          ///
          homepasscolor: kTextColorLightGrey,
          ontapart: () {
            /// nothing
          },
          ///
          artpasscolor: kPrimaryColorLight,
          ///
          ontapcreatepost: () {
            if (_user.badgeStatus == badgeVerificationApproved) {
              Navigator.pushNamed(context, createArtRoute);
            }
            else {
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
            Navigator.pushNamed(context, booksroute);
          },
          ///
          bookspasscolor:  kTextColorLightGrey,
          ///
          ontapprofile: () {
            //Navigator.pushNamed(context, myProfileRoute);
            Navigator.pushNamed(context, drawer);
          },
          ///
          passimagesource: _user.image,
        ),
          ),
    );
  }
}
