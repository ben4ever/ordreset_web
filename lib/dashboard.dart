import 'dart:async';

import 'package:angular_components/angular_components.dart';
import 'package:angular/angular.dart';

import 'package:ordreset/api.dart';
import 'package:ordreset/order_component.dart';

@Component(
  selector: 'dashboard',
  templateUrl: 'dashboard.html',
  directives: const [
    CORE_DIRECTIVES,
    OrderComponent,
    materialDirectives,
  ],
)
class Dashboard implements AfterViewInit {
  @override
  ngAfterViewInit() {}
}
