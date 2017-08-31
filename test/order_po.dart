import 'dart:async';

import 'package:pageloader/objects.dart';

class OrderPO {
  @ByTagName('td')
  List<PageLoaderElement> _tds;

  @ByTagName('material-fab')
  List<PageLoaderElement> _buttons;

  Future<String> getTdText(int index) => _tds[index].visibleText;
}
