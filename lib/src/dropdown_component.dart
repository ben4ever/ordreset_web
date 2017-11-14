import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'order_service.dart';

abstract class DropdownComponent implements OnInit, HasDropdownType {
  StreamStringSelectionOptions<DropdownEntry> options;
  SelectionModel<DropdownEntry> model;
  OrderService _orderService;
  DropdownType _type;

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  DropdownComponent(this._type, this._orderService) {
    options =
        new StreamStringSelectionOptions(_orderService.getOptionsStream(this));
    model = new SelectionModel.withList();
  }

  @override
  ngOnInit() {
    model.selectionChanges.listen(
        (_) => _orderService.select(this, model.selectedValues.toList()));
  }

  @override
  DropdownType get dropdownType => _type;

  String get buttonText {
    switch (model.selectedValues.length) {
      case 0:
        return 'all';
      case 1:
        return itemRenderer(model.selectedValues.first);
      default:
        return model.selectedValues.map(itemRenderer).join(', ');
      // TODO. Need this?
      //String s = itemRenderer(model.selectedValues.join(', '));
      //if (s.length > 10) {
      //  return s.substring(0, 8) + '...';
      //}
    }
  }

  ItemRenderer<DropdownEntry> get itemRenderer => (de) => '$de';

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      new Future<Null>(() {
        searchbox.focus();
      });
    }
  }
}

@Component(
  selector: 'my-date-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    MaterialSelectSearchboxComponent,
    MaterialDropdownSelectComponent,
  ],
)
class DateDropdownComponent extends DropdownComponent {
  DateDropdownComponent(OrderService service)
      : super(DropdownType.Date, service);
}

@Component(
  selector: 'my-procstatus-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    MaterialSelectSearchboxComponent,
    MaterialDropdownSelectComponent,
  ],
)
class ProcStatusDropdownComponent extends DropdownComponent {
  ProcStatusDropdownComponent(OrderService service)
      : super(DropdownType.ProcStatus, service);
}

@Component(
  selector: 'my-procresult-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    MaterialSelectSearchboxComponent,
    MaterialDropdownSelectComponent,
  ],
)
class ProcResultDropdownComponent extends DropdownComponent {
  ProcResultDropdownComponent(OrderService service)
      : super(DropdownType.ProcResult, service);
}

class StreamStringSelectionOptions<T> extends StringSelectionOptions<T> {
  StreamSubscription _streamSub;
  StreamStringSelectionOptions(
      Stream<List<OptionGroup<T>>> optionGroupListStream)
      : super([]) {
    _streamSub =
        optionGroupListStream.listen((newOptions) => optionGroups = newOptions);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSub?.cancel();
  }
}
