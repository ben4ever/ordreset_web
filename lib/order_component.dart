import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';

@Component(
    selector: 'my-order',
    templateUrl: 'order_component.html',
    directives: const [materialDirectives])
class OrderComponent {
  @Input('order')
  Order order;
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
