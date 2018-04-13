import 'dart:async';

class Blocker {
  final _streamCont = new StreamController<Null>();
  StreamIterator<Null> _streamIt;

  Blocker() {
    _streamIt = new StreamIterator(_streamCont.stream);
  }

  Future<bool> block() => _streamIt.moveNext();

  void unblock() {
    _streamCont.add(null);
  }
}
