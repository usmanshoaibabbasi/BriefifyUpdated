/// home screen
import 'dart:async';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/fragments/art_fragment.dart';
import 'package:briefify/fragments/home_fragment.dart';
import 'package:briefify/fragments/search_fragment.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/services/firebase_message_service.dart';
import 'package:briefify/widgets/header.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  /// Deep Linking
  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandart;
  BranchEvent? eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();
  /// Deep Linking

  @override
  void initState() {
    listenDynamicLinks();
    initDeepLinkData();
    FirebaseMessageService.startMessageListener(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// global key
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    /// user provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
          body: const HomeFragment(),
        bottomSheet: bottomportion(
          context: context,
          ///
          ontaphome: () {
          },
          ///
          homepasscolor: kPrimaryColorLight,
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
        )
      ),
    );
  }
  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(
            '------------------------------------Link clicked----------------------------------------------');
        // print('Custom title: ${data['title']}');
        print('Custom postId: ${data['postId']}');
        var a = data['postId'];
        print(a);
        // print('Custom imageUrl: ${data['imageUrl']}');
        // print('Custom bool: ${data['custom_bool']}');
        // print('Custom list number: ${data['custom_list_number']}');
        if (a != null || a != '') {
          // Means we need to navigate to next page
          print('Link Found');
          Navigator.pushReplacementNamed(context, urlRoute,
              arguments: {'postID': a});
        } else {
          print('Link Not Found');
          SnackBarHelper.showSnackBarWithoutAction(
            context,
            message: 'Something Wrong:',
          );
        }

        print(
            '------------------------------------------------------------------------------------------------');
        // SnackBarHelper.showSnackBarWithoutAction(
        //   context,
        //   message: 'Link clicked: Custom string - ${data['postId']}',
        // );
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
      ..addCustomMetadata('custom_string', 'abc')
      ..addCustomMetadata('custom_number', 12345)
      ..addCustomMetadata('custom_bool', true)
      ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
      ..addCustomMetadata('custom_list_string', ['a', 'b', 'c'])
    //--optional Custom Metadata
      ..contentSchema = BranchContentSchema.COMMERCE_PRODUCT
      ..price = 50.99
      ..currencyType = BranchCurrencyType.BRL
      ..quantity = 50
      ..sku = 'sku'
      ..productName = 'productName'
      ..productBrand = 'productBrand'
      ..productCategory = BranchProductCategory.ELECTRONICS
      ..productVariant = 'productVariant'
      ..condition = BranchCondition.NEW
      ..rating = 100
      ..ratingAverage = 50
      ..ratingMax = 100
      ..ratingCount = 2
      ..setAddress(
          street: 'street',
          city: 'city',
          region: 'ES',
          country: 'Brazil',
          postalCode: '99999-987')
      ..setLocation(31.4521685, -114.7352207);

    buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        //parameter canonicalUrl
        //If your content lives both on the web and in the app, make sure you set its canonical URL
        // (i.e. the URL of this piece of content on the web) when building any BUO.
        // By doing so, we’ll attribute clicks on the links that you generate back to their original web page,
        // even if the user goes to the app instead of your website! This will help your SEO efforts.
        // canonicalUrl: 'https://flutter.dev',
        title: 'Flutter Branch Plugin',
        imageUrl:
        'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Flutter Branch Description',
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),

        // contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec: DateTime.now()
            .add(const Duration(days: 365))
            .millisecondsSinceEpoch);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //parameter alias
        //Instead of our standard encoded short url, you can specify the vanity alias.
        // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
        // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
        //alias: 'https://branch.io' //define link url,
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('referring_user_id', 'asdf');

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART)
    //--optional Event data
      ..transactionID = '12344555'
      ..currency = BranchCurrencyType.BRL
      ..revenue = 1.5
      ..shipping = 10.2
      ..tax = 12.3
      ..coupon = 'test_coupon'
      ..affiliation = 'test_affiliation'
      ..eventDescription = 'Event_description'
      ..searchQuery = 'item 123'
      ..adType = BranchEventAdType.BANNER
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');

    eventCustom = BranchEvent.customEvent('Custom_event')
      ..addCustomData(
          'Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
      ..addCustomData(
          'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }
}
