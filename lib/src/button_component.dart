import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:http/http.dart';

@Component(
  selector: 'my-button',
  templateUrl: 'button_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  exports: const [ActionState],
)
class ButtonComponent {
  @Input('icon')
  String icon;

  @Input('actionFunc')
  Future<Null> Function() runAction;

  ActionState state;

  ButtonComponent() : state = ActionState.Idle;

  Future<Null> click() async {
    state = ActionState.Requested;
    try {
      await runAction();
      state = ActionState.Success;
    } on ClientException {
      state = ActionState.Error;
    }
    await new Future.delayed(const Duration(seconds: 1));
    state = ActionState.Idle;
  }
}

enum ActionState { Idle, Requested, Error, Success }
