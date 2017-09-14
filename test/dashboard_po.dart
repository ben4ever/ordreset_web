import 'dart:async';

import 'package:pageloader/objects.dart';

class DashboardPO {
  @ByCss('my-order material-fab')
  Lazy<List<PageLoaderElement>> _actionButtons;

  @ByCss('modal material-fab')
  Lazy<PageLoaderElement> _saveXmlButton;

  Future clickActionButton(int index) async =>
      (await _actionButtons())[index].click();

  Future clickSaveXmlButton() async => (await _saveXmlButton()).click();
}
