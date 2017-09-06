@Tags(const ['aot'])
@TestOn('browser')

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_test/angular_test.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:ordreset/src/api.dart';
import 'package:ordreset/src/order_component.dart';
import 'package:ordreset/testing.dart';
import 'order_po.dart';

@AngularEntrypoint()
void main() {
  OrderPO po;
  NgTestFixture<ParentComponent> fixture;
  List<Request> requests;

  tearDown(disposeAnyRunningTest);

  setUp(() async {
    requests = new List<Request>();
    final testBed = new NgTestBed<ParentComponent>().addProviders([
      provide(BaseClient, useFactory: () => mockClientFactory(requests: requests)),
      provide(Api, useClass: Api, deps: [BaseClient]),
      materialProviders,
    ]);
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(OrderPO);
    await fixture.update();
  });

  test('check initial state', () async {
    int idx = 0;
    for (var val in [
      '1',
      '2017-01-02 04:08:16',
      'partner1',
      'msgtype1',
      'procdesc1',
      'procmsg1',
      'errmsg1'
    ]) {
      expect(await po.getTdText(idx++), val);
      expect(await po.buttons, hasLength(3));
    }
  });

  test('click "viewXml"', () async {
    await po.clickButton(0);
    // Wait for click to be completed (can't use `fixture.update` as it will not
    // complete).
    await new Future.delayed(const Duration(milliseconds: 100));
    expect(await po.spinners, hasLength(1));
    await new Future.delayed(const Duration(milliseconds: 700));
    expect(await po.iconsDone, hasLength(1));
    await new Future.delayed(const Duration(milliseconds: 1100));
    expect(await po.buttons, hasLength(3));
    expect(requests, hasLength(1));
  });
}

@Component(
  selector: 'my-parent',
  template: '<my-order [order]="order1"></my-order>',
  directives: const [OrderComponent],
)
class ParentComponent {
  Order get order1 => new Order(1, new DateTime(2017, 1, 2, 4, 8, 16),
      'partner1', 'msgtype1', 'procdesc1', 'procmsg1', 'errmsg1');
}
