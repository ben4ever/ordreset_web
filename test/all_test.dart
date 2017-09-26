@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:test/test.dart';

import 'order.dart' as order;
import 'dashboard.dart' as dashboard;
import 'order_service.dart' as orderService;

@AngularEntrypoint()
void main() {
  group('order:', order.main);
  group('dashboard:', dashboard.main);
  group('order_service:', orderService.main);
}
