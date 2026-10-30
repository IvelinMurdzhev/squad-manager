import 'package:flutter/foundation.dart';

/// State of the Welcome intro slider.
class WelcomeViewModel extends ChangeNotifier {
  WelcomeViewModel({this.slideCount = 4}) : assert(slideCount > 0);

  final int slideCount;
  int _index = 0;

  int get index => _index;

  /// Index of the slide before the current one, wrapping around.
  int get previousIndex => (_index + slideCount - 1) % slideCount;

  /// Index of the slide after the current one, wrapping around.
  int get nextIndex => (_index + 1) % slideCount;

  void setIndex(int value) {
    if (value == _index || value < 0 || value >= slideCount) return;
    _index = value;
    notifyListeners();
  }
}
