import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-button',
  templateUrl: 'button_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
)
class ButtonComponent {
  @Input('icon')
  String icon;

  @Input('actionFunc')
  Future<Null> Function() runAction;

  bool isLoading = false;

  Future<Null> click() async {
    isLoading = true;
    await runAction();
    isLoading = false;
  }
}
