import 'dart:async';

import 'package:pageloader/objects.dart';

class DashboardPO {
  @ByCss('my-order material-fab')
  Lazy<List<PageLoaderElement>> _actionButtons;

  @ByCss('material-dialog material-fab')
  Lazy<List<PageLoaderElement>> _dialogButtons;

  Future clickActionButton(int index) async =>
      (await _actionButtons())[index].click();

  Future clickDialogButton(int index) async => (await _dialogButtons())[index].click();
}
