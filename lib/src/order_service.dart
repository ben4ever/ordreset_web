import 'dart:async';

import 'api.dart';
import 'order.dart';

class OrderService {
  final List<Order> _orders;
  final _visOrdStreamCont = new StreamController<List<Order>>();
  final _dropDataMap = <DropdownType, DropdownData>{
    DropdownType.Date: new DateDropdownData(),
    DropdownType.ProcStatus: new ProcStatusDropdownData(),
    DropdownType.ProcResults: new ProcResultsDropdownData(),
  };
  Api _api;

  OrderService(this._api) {
    _initOrders();
  }

  Future<Null> _initOrders() async {
    _orders = await _api.getOrders();
    _updateStates();
  }

  void _updateStates() {
    // TODO. Schedule function call in new async fn in case processing takes too
    // long.
    var visibleOrders = _orders
        .where((order) => _dropDataMap.values.every((dd) => dd.matches(order)));
    _visOrdStreamCont.add(visibleOrders);
    _dropDataMap.values.forEach((dd) => dd.updateOptions(_orders));
  }

  Stream<List<Order>> get visibleOrders => _visOrdStreamCont.stream;

  Stream<List<OptionGroup<DropdownEntry>>> getOptionsStream(
          HasDropdownType obj) =>
      _dropDataMap[obj.dropdownType].optionsStream;

  void select(HasDropdownType obj, List<DropdownEntry> selected) {
    _dropDataMap[obj.dropdownType].select(selected);
    _updateStates();
  }
}

abstract class DropdownData {
  final _options = new StreamController<List<OptionGroup<DropdownEntry>>>();
  final _selectStreamCont = new StreamController<List<DropdownEntry>>();
  final _selected = <DropdownEntry>[];

  Stream<List<OptionGroup<DropdownEntry>>> get optionsStream => _options.stream;

  void select(List<DropdownEntry> selected) => _selected = selected;

  String getOrderField(Order order);

  bool matches(Order order) =>
      _selected.any((de) => de.value == getOrderField(order));

  void updateOptions(List<Order> orders) {
    var options = orders.map((order) => getOrderField(order)).toSet().toList()
      ..sort();
    _options.add([new OptionGroup(options)]);
  }
}

class DateDropdownData extends DropdownData {
  @override
  String getOrderField(Order order) => order.eventTimeDate;
}

/// TODO. Make `DropdownEntry` generic by declaring it as `DropdownEntry<T>` to
/// then specify its value as `T _value` instead. Then write custom `toString`
/// methods that can be passed to `DropdownEntry`'s constructor for rendering
/// the value.
class DropdownEntry {
  String _value;
  int _cnt;

  DropdownEntry(this._value, this._cnt);

  String get value => _value;

  @override
  String toString() => '($_cnt) $_value';
}

enum DropdownType { Date, ProcStatus, ProcResults }

abstract class HasDropdownType {
  DropdownType get dropdownType;
}
