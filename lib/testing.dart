import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';

import 'src/application_tokens.dart';

@Injectable()
MockClient mockClientFactory(
        @Optional() @Inject(requestList) List<Request> requests,
        @Optional() @Inject(blockApi) Future<Null> Function() blockFunc) =>
    new MockClient(new TestClient(requests, blockFunc).handler);

class TestClient {
  List<Request> _requests;
  Future<Null> Function() _blockFunc;

  TestClient(this._requests, this._blockFunc);

  Future<Response> handler(Request request) async {
    _requests?.add(request);
    var path = request.url.pathSegments.sublist(1);

    dynamic data;
    if (_eq(['orders'], path)) {
      switch (request.method) {
        case 'GET':
          data = new List.generate(
              10,
              (i) => {
                    'id': i,
                    'eventTime': new DateFormat('yyyy-MM-ddTHH:mm:ss').format(
                        new DateTime(2017, 1, 1)
                            .add(new Duration(hours: i * 6))),
                    'partner': 'partner$i',
                    'msgType': 'msgtype$i',
                    'procEnv': 'procenv$i',
                    'procStateDesc': 'procstate${i % 3}',
                    'procMsg': 'procmsg$i',
                    'procResDesc': 'procres${i % 2}',
                  });
          break;
      }
    } else if (path[0] == 'orders' &&
        int.parse(path[1], onError: (_) => null) is int) {
      switch (request.method) {
        case 'GET':
          data = {
            'id': int.parse(path[1]),
            'xml': '<?xml version="1.0"?>\n'
                '<parent>\n'
                '  <child>foo</child>\n'
                '</parent>',
          };
          break;
        case 'POST':
          data = {'id': int.parse(path[1]), 'status': 'updated'};
          break;
      }
    }
    if (_blockFunc != null) {
      await _blockFunc();
    }
    return new Response(JSON.encode(data), 200,
        headers: {'content-type': 'application/json'});
  }

  static bool _eq(List<String> pathTest, List<String> pathIs) =>
      const IterableEquality().equals(pathTest, pathIs);
}
