@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:test/test.dart';

import 'order.dart' as order;

@AngularEntrypoint()
void main() {
  group('order:', order.main);
}
