import 'dart:async';

import 'order.dart';
import 'order_service.dart';

class PaginationService {
  OrderService _orderService;
  int _page = 0;
  int _totalPages;
  final int _ordersPerPage = 100;
  List<Order> _allOrders;
  final _ordersForPage = new StreamController<List<Order>>();

  PaginationService(this._orderService) {
    _orderService.visibleOrders.listen((_visOrders) {
      _allOrders = _visOrders;
      _page = 0;
      _totalPages = (_allOrders.length / _ordersPerPage).ceil() - 1;
      _update();
    });
  }

  void _update() {
    final newOrders = _allOrders
        .skip(_page * _ordersPerPage)
        .take(_ordersPerPage)
        .toList(growable: false);
    _ordersForPage.add(newOrders);
  }

  void prevPage() {
    if (_page > 0) {
      _page--;
      _update();
    }
  }

  void nextPage() {
    if (_page < _totalPages) {
      _page++;
      _update();
    }
  }

  int get pageCur => _page;

  int get pagesTotal => _totalPages;

  Stream<List<Order>> get ordersForPage => _ordersForPage.stream;
}
