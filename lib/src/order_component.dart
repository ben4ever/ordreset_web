import 'dart:async';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';

import 'button_component.dart';

@Component(
  selector: 'my-order',
  templateUrl: 'order_component.html',
  directives: const [ButtonComponent],
)
class OrderComponent {
  @Input('order')
  Order order;

  Future<Null> editXml() async {
    await common();
  }

  Future<Null> resubmit() async {
    await common();
  }

  Future<Null> cancel() async {
    await common();
  }

  Future common() => new Future.delayed(const Duration(milliseconds: 500));
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
