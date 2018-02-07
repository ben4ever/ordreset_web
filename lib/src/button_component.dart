import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'application_tokens.dart';
import 'exception.dart';

@Component(
  selector: 'my-button',
  templateUrl: 'button_component.html',
  directives: const [materialDirectives, CORE_DIRECTIVES],
  exports: const [ActionState],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class ButtonComponent {
  ChangeDetectorRef _ref;

  @Input('icon')
  String icon;

  @Input('actionFunc')
  Future<Null> Function() runAction;

  @Input('toIdleFunc')
  void Function() toIdleFunc;

  @Input('setErrorFunc')
  void Function(String) setErrorFunc;

  ActionState state;
  Future<Null> Function() _blockFuture;

  ButtonComponent(this._ref, @Inject(blockIconChange) this._blockFuture)
      : state = ActionState.Idle;

  Future<Null> click() async {
    state = ActionState.Requested;
    if (setErrorFunc != null) {
      setErrorFunc(null);
    }
    _ref.markForCheck();
    var success = true;
    try {
      await runAction();
      state = ActionState.Success;
    } on RetryException catch (e) {
      if (setErrorFunc != null) {
        setErrorFunc('$e');
      }
      state = ActionState.Error;
      success = false;
    }
    _ref.markForCheck();
    await _blockFuture();
    state = ActionState.Idle;
    _ref.markForCheck();
    if (success && toIdleFunc != null) {
      toIdleFunc();
    }
  }
}

enum ActionState { Idle, Requested, Error, Success }
