import 'package:angular/core.dart';

import 'package:ordreset/cust_data.dart';

@Component(selector: 'my-order-cat', templateUrl: 'order_component.html')
class OrderCatComponent {
  @Input('myOrderCat')
  OrderCat orderCat;
}
