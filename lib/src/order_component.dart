import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';

import 'button_component.dart';
import 'api.dart';

@Component(
  selector: 'my-order',
  templateUrl: 'order_component.html',
  directives: const [ButtonComponent, materialDirectives],
)
class OrderComponent {
  Api _api;

  @Input('order')
  Order order;

  OrderComponent(this._api);

  Future<Null> viewXml() async {
    (await _api.getOrder(order.id))['xml'];
  }

  Future<Null> updateXml() async {
    await _api.updateOrder(order.id, node: null);
  }

  Future<Null> resubmit() async {
    await _api.updateOrder(order.id, resubmit: true);
  }

  Future<Null> cancel() async {
    await _api.updateOrder(order.id, cancel: true);
  }
}

class Order {
  int id;
  DateTime eventTime;
  String partner;
  String msgType;
  String procDesc;
  String procMsg;
  String errMsg;

  Order(this.id, this.eventTime, this.partner, this.msgType, this.procDesc,
      this.procMsg, this.errMsg);

  String get eventTimeStr =>
      new DateFormat('yyyy-MM-dd HH:mm:ss').format(eventTime);
}
