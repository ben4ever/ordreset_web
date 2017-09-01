import 'package:angular/angular.dart';

import 'package:ordreset/order_component.dart';

@Component(
  selector: 'dashboard',
  templateUrl: 'dashboard.html',
  directives: const [
    CORE_DIRECTIVES,
    OrderComponent,
  ],
)
class Dashboard implements AfterViewInit {
  @override
  ngAfterViewInit() {}
}
