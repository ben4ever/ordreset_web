import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
  String desc;

  Order(this.id, this.desc);
}
