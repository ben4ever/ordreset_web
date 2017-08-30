@Tags(const ['aot'])
@TestOn('browser')

import 'dart:async';
import 'dart:html';

import 'package:angular_components/angular_components.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular/angular.dart';
import 'package:test/test.dart';

import 'package:ordreset/order_component.dart';
import 'order_po.dart';

@AngularEntrypoint()
void main() {
  OrderPO po;
  NgTestFixture<ParentComponent> fixture;

  tearDown(disposeAnyRunningTest);

  setUp(() async {
    final testBed = new NgTestBed<ParentComponent>();
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(OrderPO);
    await fixture.update();
  });

  test('check initial state', () async {
    expect(await po.getTdText(1), 'foo');
  });
}

@Component(
  selector: 'my-parent',
  template: '<my-order [order]="order1"></my-order>',
  directives: const [OrderComponent],
)
class ParentComponent {
  Order order1 = new Order(1, 'foo');
}
