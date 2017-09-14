import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';

import 'src/application_tokens.dart';

@Injectable()
MockClient mockClientFactory(@Inject(requestList) List<Request> requests,
        @Inject(blockApi) Future<Null> blockFuture) =>
    new MockClient(new TestClient(requests, blockFuture).handler);

class TestClient {
  List<Request> _requests;
  Future<Null> _blockFuture;

  TestClient(this._requests, this._blockFuture);

  Future<Response> handler(Request request) async {
    _requests?.add(request);
    var path = request.url.pathSegments.sublist(1);

    dynamic data;
    if (_eq(['orders'], path)) {
      switch (request.method) {
        case 'GET':
          data = [
            {
              'id': 1,
              'eventTime': '2017-01-02T04:08:16',
              'partner': 'partner1',
              'msgType': 'msgtype1',
              'procDesc': 'procdesc1',
              'procMsg': 'procmsg1',
              'errMsg': 'errmsg1',
            },
            {
              'id': 2,
              'eventTime': '2016-01-02T04:08:16',
              'partner': 'partner2',
              'msgType': 'msgtype2',
              'procDesc': 'procdesc2',
              'procMsg': 'procmsg2',
              'errMsg': 'errmsg2',
            },
          ];
          break;
      }
    } else if (_eq(['orders', '1'], path) || _eq(['orders', '2'], path)) {
      switch (request.method) {
        case 'GET':
          data = {
            'id': int.parse(path[1]),
            'xml': '<?xml version="1.0"?>'
                '<parent>'
                '  <child>foo</child>'
                '</parent>',
          };
          break;
        case 'POST':
          break;
      }
    }
    await _blockFuture;
    return new Response(JSON.encode(data), 200,
        headers: {'content-type': 'application/json'});
  }

  static bool _eq(List<String> pathTest, List<String> pathIs) =>
      const IterableEquality().equals(pathTest, pathIs);
}
