import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:http/http.dart';

import 'application_tokens.dart';

@Component(
  selector: 'my-button',
  templateUrl: 'button_component.html',
  directives: const [materialDirectives, CORE_DIRECTIVES],
  exports: const [ActionState],
)
class ButtonComponent {
  @Input('icon')
  String icon;

  @Input('actionFunc')
  Future<Null> Function() runAction;

  @Input('toIdleFunc')
  void Function() toIdleFunc;

  ActionState state;
  Future<Null> Function() _blockFuture;

  ButtonComponent(@Inject(blockIconChange) this._blockFuture)
      : state = ActionState.Idle;

  Future<Null> click() async {
    state = ActionState.Requested;
    try {
      await runAction();
      state = ActionState.Success;
    } on ClientException {
      state = ActionState.Error;
    }
    await _blockFuture();
    state = ActionState.Idle;
    if (toIdleFunc != null) {
      toIdleFunc();
    }
  }
}

enum ActionState { Idle, Requested, Error, Success }
