import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:xml/xml.dart' as xml;

import 'api.dart';
import 'button_component.dart';
import 'dropdown_component.dart';
import 'order.dart';
import 'order_component.dart';
import 'pagination_service.dart';

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
  Api _api;
  PaginationService _paginationService;
  bool showDialog = false;
  Order _dialogOrder;

  @ViewChild(MaterialMultilineInputComponent)
  MaterialMultilineInputComponent xmlInput;

  DashboardComponent(this._api, this._paginationService);

  Stream<List<Order>> get orders => _paginationService.ordersForPage;

  int get pageCur => _paginationService.pageCur;

  int get pagesTotal => _paginationService.pagesTotal;

  void nextPage() => _paginationService.nextPage();

  void prevPage() => _paginationService.prevPage();

  @override
  ngOnInit() {
    xmlInput.inputRef.nativeElement.style
        .setProperty('font-family', 'monospace');
  }

  Future<Null> Function() getOpenDialogFunc(Order order) => () async {
        _dialogOrder = order;
        var xmlText = (await _api.getOrder(_dialogOrder.id))['xml'];
        xmlInput.inputText = xml.parse(xmlText).toXmlString(pretty: true);
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
