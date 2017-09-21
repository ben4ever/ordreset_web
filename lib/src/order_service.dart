import 'dart:async';

import 'order.dart';

class OrderService {
  StreamController<List<Order>> _visibleOrders;
  Map<DropdownType, List<DropdownEntry>> _options;

  OrderService()
      : _visibleOrders = new StreamController<List<Order>>.broadcast(),
        _options = <DropdownType, StreamController<List<OptionGroup<DropdownEntry>>>>{
        DropdownType.Date: <DropdownEntry>[],
        DropdownType.ProcStatus: <DropdownEntry>[],
        DropdownType.ProcResults: <DropdownEntry>[],
        } {
          _updateOptions();
  }

  Stream<List<OptionGroup<DropdownEntry>>> getOptionsStream(DropdownType type) {
    _options[type];
    Map<DropdownType, Stream<List<OptionGroup<DropdownEntry>>>>
  }
}

class DropdownEntry {
  String _label;
  int _cnt;

  DropdownEntry(this._label, this._cnt);

  @override
  String toString() => '($_cnt) $_label';
}

enum DropdownType { Date, ProcStatus, ProcResults }
