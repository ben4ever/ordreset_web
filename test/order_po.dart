import 'dart:async';

import 'package:pageloader/objects.dart';

class OrderPO {
  @ByTagName('td')
  List<PageLoaderElement> _tds;

  @ByTagName('material-fab')
  List<PageLoaderElement> _buttons;

  @ByTagName('material-spinner')
  Lazy<List<PageLoaderElement>> _spinners;

  Future<String> getTdText(int index) => _tds[index].visibleText;

  Future clickButton(int index) => _buttons[index].click(sync: false);

  Future<List<PageLoaderElement>> get spinners => _spinners();
}
