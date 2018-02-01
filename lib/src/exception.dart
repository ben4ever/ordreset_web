class RetryException implements Exception {
  final String msg;

  RetryException(this.msg);

  String toString() => msg;
}

class HttpRetryException extends RetryException {
  HttpRetryException(msg) : super(msg);
}

class XmlRetryException extends RetryException {
  XmlRetryException(msg) : super(msg);
}
