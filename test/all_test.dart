@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:test/test.dart';

import 'order_component.dart' as order_component;

@AngularEntrypoint()
void main() {
  group('order_component:', order_component.main);
}
