import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'api.dart';
import 'button_component.dart';
import 'order.dart';

@Component(
  selector: 'tr[myOrder]',
  templateUrl: 'order_component.html',
  directives: const [
    ButtonComponent,
    materialDirectives,
  ],
)
class OrderComponent {
  Api _api;

  @Input('order')
  Order order;

  @Input('viewXmlFunc')
  Future<Null> Function() viewXmlFunc;

  OrderComponent(this._api);

  Future<Null> viewXml() async {
    await viewXmlFunc();
  }

  Future<Null> resubmit() async {
    await _api.updateOrder(order.id, resubmit: true);
  }

  Future<Null> cancel() async {
    await _api.updateOrder(order.id, cancel: true);
  }
}
