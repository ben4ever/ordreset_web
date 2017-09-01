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

  Future<Null> editXml(String id) async {
    await common(id);
  }

  Future<Null> resubmit(String id) async {
    await common(id);
  }

  Future<Null> cancel(String id) async {
    await common(id);
  }

  Future<Null> common(String s) async {
    print('$s clicked');
    await new Future.delayed(const Duration(seconds: 1));
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
