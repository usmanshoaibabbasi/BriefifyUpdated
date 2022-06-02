import 'package:briefify/fragments/art_fragment.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
              key: _key,
              drawer: const HomeDrawer(),
              body: const ArtFragment()),
          GestureDetector(
            onTap: () {
              _key.currentState?.openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 15,top: 20),
              child: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
