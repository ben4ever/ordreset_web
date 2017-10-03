import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart' as xml;

import 'order.dart';

@Injectable()
class Api {
  final BaseClient _client;

  Api(this._client);

  Future<List<Order>> getOrders() async {
    List<Map<String, dynamic>> orders = await _makeCall(_client.get, '/orders');
    return orders
        .map((order) => new Order.fromJson(order))
        .toList(growable: false);
  }

  Future<Map<String, dynamic>> getOrder(int id) async =>
      await _makeCall(_client.get, '/orders/${id}');

  Future<Map<String, dynamic>> updateOrder(int id,
      {xml.XmlDocument xmlDoc,
      bool resubmit = false,
      bool cancel = false}) async {
    final data = <String, dynamic>{};
    if (xmlDoc != null) {
      data['xml'] = xmlDoc.toXmlString(pretty: true);
    }
    if (resubmit) {
      data['resubmit'] = true;
    }
    if (cancel) {
      data['cancel'] = true;
    }
    return await _makeCall(_client.post, '/orders/${id}', data);
  }

  Future<dynamic> _makeCall(Function fn, String uri, [dynamic body]) async {
    Response resp;
    try {
      uri = 'api$uri';
      if (body == null || (body is Map && body.isEmpty)) {
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
