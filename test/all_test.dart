@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:test/test.dart';

import 'order.dart' as order;
import 'dashboard.dart' as dashboard;
import 'dropdown.dart' as dropdown;

@AngularEntrypoint()
void main() {
  group('order:', order.main);
  group('dashboard:', dashboard.main);
  group('dropdown:', dropdown.main);
}
