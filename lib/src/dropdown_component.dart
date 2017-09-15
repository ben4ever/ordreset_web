import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'api.dart';

@Component(
  selector: 'my-dropdown',
  templateUrl: 'dropdown_component.html',
  directives: const [
    materialDirectives,
  ],
)
class DropdownComponent implements OnInit {
  Api _api;

  DropdownComponent(this._api) {
    selectOptions = new SelectionOptions<Map<String, String>>.fromFuture(
        new Future(() async {
      availablePartners = await _api.getPartners();
      return [new OptionGroup(availablePartners)];
    }));
  }

  @override
  ngOnInit() {
    _handleDropdownSelectionChanges();
  }

  var dropdownSelectModel =
      new RadioGroupSingleSelectionModel<Map<String, String>>();

  var selectOptions;

  String get buttonText => dropdownSelectModel.isEmpty
      ? 'Select partner'
      : itemRenderer(dropdownSelectModel.selectedValue);

  ItemRenderer<Map<String, String>> get itemRenderer =>
      (partner) => partner['name'];

  Future<Null> _handleDropdownSelectionChanges() async {
    await for (var changeList in dropdownSelectModel.selectionChanges) {
      setPartner(changeList.last.added.last);
    }
  }

  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      new Future<Null>(() => searchbox.focus());
    }
  }
}
