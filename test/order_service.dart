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
import 'package:ordreset/src/order_service.dart';
import 'package:ordreset/testing.dart';
import 'order_po.dart';

@AngularEntrypoint()
void main() {
  var blockers = {
    'api': new Blocker(),
  };

  var serv = new Injector.slowReflective([
    provide(blockApi, useValue: blockers['api'].block),
    provide(BaseClient, useFactory: mockClientFactory),
    provide(Api, useClass: Api, deps: [BaseClient]),
    OrderService,
  ]).get(OrderService);

  tearDown(disposeAnyRunningTest);

  test('use injected service', () async {
    blockers['api'].unblock();
    expect(serv, new isInstanceOf<OrderService>());
  });
}
