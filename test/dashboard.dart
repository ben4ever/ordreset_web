@Tags(const ['aot'])
@TestOn('browser')

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_test/angular_test.dart';
import 'package:http/http.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'package:ordreset/src/api.dart';
import 'package:ordreset/src/application_tokens.dart';
import 'package:ordreset/src/dashboard_component.dart';
import 'package:ordreset/testing.dart';
import 'dashboard_po.dart';

PageLoader Function(Element el, NgTestFixture<DashboardComponent> fixture)
    _getCreatePageLoaderFunc(Element el) {
  return (_, fixture) => new HtmlPageLoader(el, executeSyncedFn: (fn) async {
        await fn();
        return fixture.update();
      });
}

@AngularEntrypoint()
void main() {
  DashboardPO po;
  NgTestFixture<DashboardComponent> fixture;
  List<Request> requests;
  Completer<Null> blockApiCompleter;
  Completer<Null> blockIconChangeCompleter;

  tearDown(disposeAnyRunningTest);

  setUp(() async {
    blockApiCompleter = new Completer<Null>();
    blockIconChangeCompleter = new Completer<Null>();
    requests = new List<Request>();

    var parentDiv = new DivElement(),
        hostDiv = new DivElement(),
        overlayContDiv = new DivElement();
    parentDiv.children..add(hostDiv)..add(overlayContDiv);
    final testBed = new NgTestBed<DashboardComponent>(host: hostDiv)
        .setPageLoader(_getCreatePageLoaderFunc(parentDiv))
        .addProviders([
      provide(blockApi, useValue: blockApiCompleter.future),
      provide(blockIconChange, useValue: blockIconChangeCompleter.future),
      provide(requestList, useValue: requests),
      provide(BaseClient, useFactory: mockClientFactory),
      provide(Api, useClass: Api, deps: [BaseClient]),
      materialProviders,
      provide(overlayContainerParent, useValue: overlayContDiv),
    ]);
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(DashboardPO);
    await fixture.update();
  });

  test('check initial state', () async {
    blockApiCompleter.complete();
    expect(requests, hasLength(1));
    await fixture.update((c) {
      expect(c.orders, hasLength(2));
    });
  });

  group('click "resubmit"', () {
    setUp(() async {
      blockApiCompleter.complete();
      await fixture.update();
      await po.clickActionButton(1);
      blockApiCompleter.complete();
      blockIconChangeCompleter.complete();
    });

    test('click "save XML"', () async {
      await po.clickSaveXmlButton();
      expect(
          JSON.decode(requests[0].body)['xml'],
          '<?xml version="1.0"?>'
          '<parent>'
          '  <child>foo updated</child>'
          '</parent>');
    });
  });
}
