import 'dart:async';

import 'package:pageloader/objects.dart';

class OrderPO {
  @ByTagName('td')
  List<PageLoaderElement> _tds;

  @ByTagName('material-fab')
  List<PageLoaderElement> _buttons;

  @ByTagName('material-spinner')
  List<PageLoaderElement> _spinners;

  Future<String> getTdText(int index) => _tds[index].visibleText;

  Future clickButton(int index) => _buttons[index].click();

  int get spinnersCnt => _spinners.length;
}
