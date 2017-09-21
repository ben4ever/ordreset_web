import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'api.dart';
import 'application_tokens.dart';
import 'order_service.dart';

abstract class DropdownComponent implements OnInit {
  SelectionOptions<Map<String, String>> options;
  SelectionModel<Map<String, String>> model;
  OrderService _orderService;
  DropdownType _type;

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  DropdownComponent(this._type, this._orderService) {
    options = new SelectionOptions<Map<String, String>>.fromStream(
        _orderService.getOptionsStream(_type));
    model = new SelectionModel<Map<String, String>>.withList(allowMulti: true);
  }

  @override
  ngOnInit() {
    model.changes.listen((_) {
      _service.(model.selectedValues);
    });
  }

  String get buttonText {
    switch (model.selectedValues.length) {
      case 0:
        return 'all';
      case 1:
        return itemRenderer(model.selectedValues.first);
      default:
        return itemRenderer(model.selectedValues.join(', '));
        // TODO. Need this?
        //String s = itemRenderer(model.selectedValues.join(', '));
        //if (s.length > 10) {
        //  return s.substring(0, 8) + '...';
        //}
    }
    ;
  }

  ItemRenderer<Map<String, String>> get itemRenderer;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      new Future<Null>(() {
        searchbox.focus();
      });
    }
  }
}

@Component(
  selector: 'my-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    materialDirectives,
  ],
)
class DateDropdownComponent extends DropdownComponent {
  DateDropdownComponent(OrderService service) : super(DropdownType.Date, service);
}

@Component(
  selector: 'my-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    materialDirectives,
  ],
)
class ProcStatusDropdownComponent extends DropdownComponent {}

@Component(
  selector: 'my-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    materialDirectives,
  ],
)
class ProcResultDropdownComponent extends DropdownComponent {}
