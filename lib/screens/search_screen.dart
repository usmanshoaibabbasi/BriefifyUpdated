import 'package:briefify/fragments/search_fragment.dart';
import 'package:briefify/widgets/home_drawer.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
              body: const SearchFragment()),
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
