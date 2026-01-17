import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleProvider =
    NotifierProvider<TitleProvider, String>(() => TitleProvider());

class TitleProvider extends Notifier<String> {
  final titles = ['Quick Mart', 'My Cart', 'Favorites'];
  int index = 0, prevIndex = 0;
  bool inDetailScreen = false;

  @override
  String build() {
    //initial state
    state = titles[0];
    return state;
  }

  setPreviousTitle() {
    inDetailScreen = false;
    setNextTitle(prevIndex);
  }

  setNextTitle(int nextTitleIndex) {
    prevIndex = index;
    index = nextTitleIndex;
    state = titles[index];
  }

  setInDetailScreen(bool b) => inDetailScreen = b;
}
