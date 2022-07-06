import 'package:briefify/models/books_modal.dart';
import 'package:flutter/foundation.dart';

class BooksChapterProvider with ChangeNotifier {
  
  List<ChapterModal> _chapterlist_provider = [];
  List get chapterlist_provider => _chapterlist_provider;

  List<int> _intlist_provider = [];
  List get intlist_provider => _intlist_provider;

  List<int> _whichChapters_list = [];
  List get whichChapters_list => _whichChapters_list;

  int _selectedchapters = 0;
  int get selectedchapters => _selectedchapters;


  void setChapterList(List<ChapterModal> listget) {
    // if(kDebugMode) {
    //   print('Enter in setChapterList provider');
    // }
    _chapterlist_provider = listget;
    notifyListeners();
  }

  void setIntegerList(List<ChapterModal> listget) {
    for(int i = 0; i < listget.length; i++) {
      _intlist_provider.add(0);
    }
    // if(kDebugMode) {
    //   print('Finally List Is created $_intlist_provider');
    // }
    notifyListeners();
  }
  
  void selectchapter(int indexpass) {
    // if(kDebugMode) {
    //   print('Enter in selectChapter');
    // }
    if(_intlist_provider[indexpass] == 0) {
      // if(kDebugMode) {
      //   print('have value 0');
      // }
      _intlist_provider[indexpass] = 1;

    }
    else if(_intlist_provider[indexpass] == 1) {
      // if(kDebugMode) {
      //   print('have value 1');
      // }
      _intlist_provider[indexpass] = 0;

    }
    // if(kDebugMode) {
    //   print('Finally List Is created $_intlist_provider');
    // }
    _selectedchapters = intlist_provider.firstWhere((e) => e == 1, orElse: () => 0,);
    notifyListeners();
  }

  void checkWhichChapterSelected() {
    if(kDebugMode) {
      print('Enter in checkWhichChapterSelected');
    }
    _whichChapters_list.clear();
    if(kDebugMode) {
      print('Initially List Is $_whichChapters_list');
    }
    for(int i = 0; i<_intlist_provider.length; i++) {
      if(_intlist_provider[i] == 1) {
        _whichChapters_list.add(i);
        if(kDebugMode) {
          print('Item  ${i}  is added');
        }
      }
    }
    notifyListeners();
  }
}