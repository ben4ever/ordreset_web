import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:http/http.dart';

@Injectable()
class Api {
  final BaseClient _client;

  Api(this._client);

  Future<List<Map<String, String>>> getOrders() async =>
      await _makeCall(_client.get, '/orders');

  Future<Map<String, dynamic>> resetOrder(int id) async =>
      await _makeCall(_client.post, '/orders/${id}', {'reset': true});

  Future<dynamic> _makeCall(Function fn, String uri, [dynamic body]) async {
    Response resp;
    try {
      uri = 'api$uri';
      if (body == null) {
        resp = await fn('$uri');
      } else {
        resp = await fn('$uri',
            headers: {'Content-Type': 'application/json'},
            body: JSON.encode(body));
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return JSON.decode(resp.body);
  }
}
