import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:xml/xml.dart' as xml;

import 'api.dart';
import 'button_component.dart';
import 'dropdown_component.dart';
import 'order.dart';
import 'order_component.dart';
import 'order_service.dart';

@Component(
  selector: 'dashboard',
  styleUrls: const ['dashboard_component.css'],
  templateUrl: 'dashboard_component.html',
  directives: const [
    ButtonComponent,
    OrderComponent,
    DateDropdownComponent,
    ProcStatusDropdownComponent,
    ProcResultDropdownComponent,
    materialDirectives,
    CORE_DIRECTIVES,
  ],
  pipes: const [COMMON_PIPES],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class DashboardComponent implements OnInit {
  ChangeDetectorRef _ref;

  Api _api;
  OrderService _orderService;
  bool showDialog = false;
  Order _dialogOrder;
  List<Order> orders;
  final _ordersDetailsMap = <Order, Map<String, bool>>{};

  @ViewChild(MaterialMultilineInputComponent)
  MaterialMultilineInputComponent xmlInput;

  DashboardComponent(this._ref, this._api, this._orderService) {
    _orderService.orders.listen((_orders) {
      orders = _orders;
      _ordersDetailsMap.clear();
    });

    _orderService.visibleOrders.listen((_visOrders) {
      var i = 0;
      orders.forEach((order) {
        var highlight = false;
        final visible = _visOrders.contains(order);
        if (visible) {
          highlight = i++ % 2 == 1;
        }
        _ordersDetailsMap[order] = {'highlight': highlight, 'visible': visible};
      });
      _ref.markForCheck();
    });
  }

  @override
  ngOnInit() {
    xmlInput.inputRef.nativeElement.style
        .setProperty('font-family', 'monospace');
  }

  bool isVisible(Order order) => _ordersDetailsMap[order]['visible'];

  bool isHighlighted(Order order) => _ordersDetailsMap[order]['highlight'];

  Future<Null> Function() getOpenDialogFunc(Order order) => () async {
        _dialogOrder = order;
        xmlInput.inputText = (await _api.getOrder(_dialogOrder.id))['xml'];
        showDialog = true;
      };

  Future<Null> saveXml() async {
    var xmlDoc = xml.parse(xmlInput.inputText);
    // TODO. Do something with returned data from `updateOrder`?
    await _api.updateOrder(_dialogOrder.id, xmlDoc: xmlDoc);
  }

  void dismiss() {
    showDialog = false;
    xmlInput.inputText = '';
  }
}
