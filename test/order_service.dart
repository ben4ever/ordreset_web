@Tags(const ['aot'])
@TestOn('browser')

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'package:ordreset/src/api.dart';
import 'package:ordreset/src/order_service.dart';
import 'package:ordreset/testing.dart';

@AngularEntrypoint()
void main() {
  OrderService serv;

  tearDown(disposeAnyRunningTest);

  setUp(() {
    serv = new Injector.slowReflective([
      provide(BaseClient, useFactory: mockClientFactory),
      provide(Api, useClass: Api, deps: [BaseClient]),
      OrderService,
    ]).get(OrderService);
  });

  test('check initial state', () async {
    expect(await serv.visibleOrders.first, hasLength(10));
    await validateOptions(
        serv, new DateComp(), ['2017-01-01', '2017-01-02', '2017-01-03']);
    await validateOptions(
        serv, new ProcStatusComp(), ['procstate0', 'procstate1', 'procstate2']);
    await validateOptions(
        serv, new ProcResultComp(), ['<null>', 'procres0', 'procres1']);
  });

  group('select a date:', () {
    setUp(() async {
      await new Future(() {});
      var comp = new DateComp();
      var optionGroupList = await serv.getOptionsStream(comp).first;
      var optionGroup = optionGroupList.single;
      serv.select(comp, [optionGroup[2]]);
    });

    test('check procstate options', () async {
      await validateOptions(
          serv, new ProcStatusComp(), ['procstate0', 'procstate2'],
          takeStreamCnt: 2);
    });

    test('check visible orders updated', () async {
      var visOrdersList = await serv.visibleOrders.take(2).toList();
      expect(visOrdersList.last, hasLength(2));
    });
  });
}

Future<Null> validateOptions(
    OrderService serv, HasDropdownType comp, List<String> values,
    {int takeStreamCnt = 1}) async {
  var optionGroupList =
      await serv.getOptionsStream(comp).take(takeStreamCnt).last;
  var optionGroup = optionGroupList.single;
  for (List zip in new IterableZip([optionGroup, values])) {
    expect(zip[0].value, zip[1]);
  }
}

class DateComp implements HasDropdownType {
  DropdownType get dropdownType => DropdownType.Date;
}

class ProcStatusComp implements HasDropdownType {
  DropdownType get dropdownType => DropdownType.ProcStatus;
}

class ProcResultComp implements HasDropdownType {
  DropdownType get dropdownType => DropdownType.ProcResult;
}
