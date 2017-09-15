import 'dart:async';

import 'package:angular/angular.dart';

import 'package:angular_components/angular_components.dart';
import 'package:xml/xml.dart' as xml;

import 'api.dart';
import 'button_component.dart';
import 'dropdown_component.dart';
import 'order_component.dart';
import 'order.dart';

@Component(
  selector: 'dashboard',
  templateUrl: 'dashboard_component.html',
  directives: const [
    ButtonComponent,
    OrderComponent,
    DropdownComponent,
    materialDirectives,
    CORE_DIRECTIVES,
  ],
)
class DashboardComponent implements OnInit {
  Api _api;
  bool showDialog;
  Order _dialogOrder;
  List<Order> orders;

  @ViewChild(MaterialMultilineInputComponent)
  MaterialMultilineInputComponent xmlInput;
  //set xmlInput(MaterialMultilineInputComponent value) => _xmlInput = value;

  DashboardComponent(this._api) {
    showDialog = false;
  }

  Future<Null> ngOnInit() async {
    orders = await _api.getOrders();
  }

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
