import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/term_and_condition.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/drawer_item.dart';
import 'package:briefify/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// User Provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;

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
            Navigator.pushNamed(context, booksroute);
          },
          ///
          bookspasscolor:  kTextColorLightGrey,
          ontapprofile: () {
            //Navigator.pushNamed(context, myProfileRoute);
            Navigator.pushNamed(context, drawer);
          },
          ///
          passimagesource: _user.image,
        ),
        body: SingleChildScrollView(
          child: Column(
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
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: Color(0xffEFF2F7),
                            borderRadius: BorderRadius.all(Radius.circular(200)),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    /// sizedbox after icons row
                    const SizedBox(height: 25,),
                    /// picture and other content
                    Container(
                      child: Row(
                        children: [
                          /// picture
                          GestureDetector(
                            onTap: () {
                              // Display Full Image Profile
                              Navigator.pushNamed(context, ImgeScreenProfile);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: FadeInImage(
                                placeholder: const AssetImage(userAvatar),
                                image: NetworkImage(_user.image),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, object, trace) {
                                  return Image.asset(
                                    appLogo,
                                    height: 100,
                                    width: 100,
                                  );
                                },
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                          /// sizedbox after picture
                          const SizedBox(width: 20,),
                          /// content on right of picture
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    _user.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _user.occupation == '' || _user.occupation == null ? 'user city' : _user.occupation,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4,),
                                      const Icon(
                                        FontAwesomeIcons.camera,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 4,),
                                      Flexible(
                                        child: Text(
                                          _user.city == '' || _user.city == null ? 'user city' : _user.city,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    /// sized box after picture container
                    const SizedBox(height: 15,),
                    /// last containber odf post follwers
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                _user.userFollowers.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 3,),
                              const Text(
                                'Post',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                _user.userFollowers.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 3,),
                              const Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                _user.userFollowing.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 3,),
                              const Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              /// sizedbox after header
              const SizedBox(height: 15,),
              /// Menu portion
              Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    AccountSectionItems(
                      context: context,
                      ontapAccountSectionItems: () {
                        Navigator.pushNamed(context, myProfileRoute);
                      },
                      widgetpass: SizedBox(
                        width: 36,
                        height: 36,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: FadeInImage(
                            placeholder: const AssetImage(userAvatar),
                            image: NetworkImage(_user.image),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, object, trace) {
                              return Image.asset(
                                appLogo,
                                height: 36,
                                width: 36,
                              );
                            },
                            height: 36,
                            width: 36,
                          ),
                        ),
                      ),
                      title: _user.name
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                      context: context,
                      ontapAccountSectionItems: () {
                        Navigator.pushNamed(context, profileVerificationRoute);
                      },
                      widgetpass: const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        size: 36,
                        color: Colors.blue,
                      ),
                      title: 'Verification'
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          Navigator.pushNamed(context, categoriesRoute);
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.folder_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'Categories'
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          Navigator.pushNamed(context, walletRoute);
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.creditcard_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'Wallet'
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () async {
                          await FirebaseAuth.instance.signOut();
                          await Prefs().logoutUser();
                          Navigator.pushNamedAndRemoveUntil(
                              context, welcomeRoute, ModalRoute.withName(homeRoute));
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.arrow_down_left_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'Logout'
                    ),
                  ],
                ),
              ),
              /// sizedBox After Menu
              const SizedBox(height: 15,),
              /// Link portion
              Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Links',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          launchurl1(url1: 'https://briefify.io/');
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.info_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'About Us'
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          launchurl1(url1: 'https://briefify.io/');
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.question_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'FAQs'
                    ),
                  ],
                ),
              ),
              /// sizedBox After Links
              const SizedBox(height: 15,),
              /// Legal portion
              Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Legal',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TermAndConditionScreen()),
                          );
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.folder_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'Privacy Policy'
                    ),
                    const SizedBox(height: 15,),
                    AccountSectionItems(
                        context: context,
                        ontapAccountSectionItems: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TermAndConditionScreen()),
                          );
                        },
                        widgetpass: const Icon(
                          CupertinoIcons.question_circle_fill,
                          size: 36,
                          color: Colors.blue,
                        ),
                        title: 'Terms and Conditions'
                    ),
                    const SizedBox(height: 70,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchurl1({url1}) async {
    // For Url Launch Ios Info.plist
    // For Url Launch Android AndroidManifest
    var url = url1;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ImgScreenProfile extends StatelessWidget {
  const ImgScreenProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context);
    final user = _userData.user;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Image(
                  image: NetworkImage(
                    user.image,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: kPrimaryColorLight,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
