import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'src/api.dart';
import 'src/application_tokens.dart';
import 'src/dashboard_component.dart';
import 'src/order_service.dart';
import 'testing.dart';

BrowserClient browserClientFactory() => new BrowserClient();

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [DashboardComponent],
  providers: const [
    const Provider(BaseClient, useFactory: browserClientFactory),
    const Provider(Api, useClass: Api, deps: const [BaseClient]),
    const Provider(OrderService, useClass: OrderService, deps: const [Api]),
    materialProviders,
  ],
)
class AppComponent {}

Future<Null> delayFactory() =>
    new Future<Null>.delayed(const Duration(milliseconds: 500));

@Component(
  selector: 'my-app-test',
  templateUrl: 'app_component.html',
  directives: const [DashboardComponent],
  providers: const [
    const Provider(blockApi, useValue: delayFactory),
    const Provider(blockIconChange, useValue: delayFactory),
    const Provider(BaseClient, useFactory: mockClientFactory),
    const Provider(Api, useClass: Api, deps: const [BaseClient]),
    const Provider(OrderService, useClass: OrderService, deps: const [Api]),
    materialProviders,
  ],
)
class AppComponentTest {}
