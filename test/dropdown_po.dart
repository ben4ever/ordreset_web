import 'dart:async';

import 'package:pageloader/objects.dart';

class OrderPO {
  @ByCss('material-select-searchbox input')
  Lazy<PageLoaderElement> _searchboxInput;

  @ByTagName('material-fab')
  Lazy<List<PageLoaderElement>> _buttons;

  @ByTagName('material-spinner')
  Lazy<List<PageLoaderElement>> _spinners;

  @ByCss('material-icon[icon="done"]')
  Lazy<List<PageLoaderElement>> _iconsDone;

  @ByCss('material-icon[icon="error"]')
  Lazy<List<PageLoaderElement>> _iconsError;

  Future<String> getTdText(int index) => _tds[index].visibleText;

  Future<List<PageLoaderElement>> get buttons => _buttons();

  Future clickButton(int index) async => (await buttons)[index].click();

  Future<List<PageLoaderElement>> get spinners => _spinners();

  Future<List<PageLoaderElement>> get iconsDone => _iconsDone();

  Future<List<PageLoaderElement>> get iconsError => _iconsError();
}
