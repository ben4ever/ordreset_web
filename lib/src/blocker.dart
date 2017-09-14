import 'dart:async';

class Blocker {
  Completer<Null> _comp;

  Future<Null> block() {
    assert(_comp?.isCompleted ?? true);
    _comp = new Completer<Null>();
    return _comp.future;
  }

  void unblock() {
    _comp.complete();
  }
}
