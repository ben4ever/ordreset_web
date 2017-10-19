@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_test/angular_test.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:ordreset/src/api.dart';
import 'package:ordreset/src/application_tokens.dart';
import 'package:ordreset/src/blocker.dart';
import 'package:ordreset/src/order_component.dart';
import 'package:ordreset/src/order.dart';
import 'package:ordreset/testing.dart';
import 'order_po.dart';

@AngularEntrypoint()
void main() {
  OrderPO po;
  NgTestFixture<ParentComponent> fixture;
  List<Request> requests;
  Map<String, Blocker> blockers;

  tearDown(disposeAnyRunningTest);

  setUp(() async {
    blockers = {
      'api': new Blocker(),
      'iconChange': new Blocker(),
    };
    requests = <Request>[];
    final testBed = new NgTestBed<ParentComponent>().addProviders([
      provide(blockApi, useValue: blockers['api'].block),
      provide(blockIconChange, useValue: blockers['iconChange'].block),
      provide(requestList, useValue: requests),
      provide(BaseClient, useFactory: mockClientFactory),
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
      'procenv1',
      'procstate1',
      'procmsg1',
      'procres1',
    ]) {
      expect(await po.getTdText(idx++), val);
    }
    expect(await po.buttons, hasLength(3));
  });

  test('click "resubmit"', () async {
    await po.clickButton(1);
    await fixture.update();
    expect(await po.spinners, hasLength(1));

    blockers['api'].unblock();
    await fixture.update();
    expect(await po.iconsDone, hasLength(1));

    blockers['iconChange'].unblock();
    await fixture.update();
    expect(await po.buttons, hasLength(3));
    expect(requests, hasLength(1));
  });

  test('click "cancel"', () async {
    await po.clickButton(2);
    await fixture.update();
    expect(await po.spinners, hasLength(1));

    blockers['api'].unblock();
    await fixture.update();
    expect(await po.iconsDone, hasLength(1));

    blockers['iconChange'].unblock();
    await fixture.update();
    expect(await po.buttons, hasLength(3));
    expect(requests, hasLength(1));
  });
}

@Component(
  selector: 'my-parent',
  template: '<tr myOrder [order]="order1"></tr>',
  directives: const [OrderComponent],
)
class ParentComponent {
  Order get order1 => new Order(1, new DateTime(2017, 1, 2, 4, 8, 16),
      'partner1', 'msgtype1', 'procenv1', 'procstate1', 'procmsg1', 'procres1');
}
