import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'api.dart';
import 'order.dart';

@Injectable()
class OrderService {
  List<Order> _orders;
  final _visOrdStreamCont = new StreamController<List<Order>>();
  final _dropDataMap = <DropdownType, DropdownData>{
    DropdownType.Date: new DateDropdownData(),
    DropdownType.ProcStatus: new ProcStatusDropdownData(),
    DropdownType.ProcResult: new ProcResultDropdownData(),
  };
  Api _api;

  OrderService(this._api) {
    _initOrders();
  }

  Future<Null> _initOrders() async {
    _orders = await _api.getOrders();
    _dropDataMap.values.forEach((dd) => dd.initOptions(_orders));
    _updateStates();
  }

  void _updateStates() {
    // TODO. Schedule function call in new async fn in case processing takes too
    // long.
    var visOrders = _orders
        .where((order) => _dropDataMap.values.every((dd) => dd.matches(order)))
        .toList();
    _visOrdStreamCont.add(visOrders);
    _dropDataMap.values.forEach((dd) => dd.updateOptions(visOrders));
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
  final _visOptionsStreamCont =
      new StreamController<List<OptionGroup<DropdownEntry>>>();
  List<DropdownEntry> _options;
  var _selected = <DropdownEntry>[];

  void initOptions(List<Order> orders) {
    _options = orders
        .map((order) => _getOrderField(order))
        .toSet()
        .map((str) => new DropdownEntry(str))
        .toList(growable: false)
          ..sort();
  }

  Stream<List<OptionGroup<DropdownEntry>>> get optionsStream =>
      _visOptionsStreamCont.stream;

  void select(List<DropdownEntry> selected) {
    _selected = selected;
  }

  String _getOrderField(Order order);

  bool matches(Order order) =>
      _selected.isEmpty ||
      _selected.any((de) => de.value == _getOrderField(order));

  void updateOptions(List<Order> orders) {
    var options = orders
        .map((order) => _getOrderField(order))
        .toSet()
        .map((orderStr) => _options.firstWhere(
            (option) => orderStr == option.value,
            orElse: () => null))
        .where((option) => option != null)
        .toList()
          ..sort();
    _visOptionsStreamCont.add([new OptionGroup(options)]);
  }
}

class DateDropdownData extends DropdownData {
  @override
  String _getOrderField(Order order) => order.eventTimeDate;
}

class ProcStatusDropdownData extends DropdownData {
  @override
  String _getOrderField(Order order) => order.procStateDesc;
}

class ProcResultDropdownData extends DropdownData {
  @override
  String _getOrderField(Order order) => order.procResDesc;
}

/// TODO. Make `DropdownEntry` generic by declaring it as `DropdownEntry<T>` to
/// then specify its value as `T _value` instead. Then write custom `toString`
/// methods that can be passed to `DropdownEntry`'s constructor for rendering
/// the value.
class DropdownEntry implements Comparable<DropdownEntry> {
  String _value;

  DropdownEntry(this._value);

  String get value => _value;

  @override
  String toString() => '$value';

  @override
  int compareTo(DropdownEntry other) => value.compareTo(other.value);
}

enum DropdownType { Date, ProcStatus, ProcResult }

abstract class HasDropdownType {
  DropdownType get dropdownType;
}
