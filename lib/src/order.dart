import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

class Order {
  int id;
  DateTime eventTime;
  String partner;
  String msgType;
  String procEnv;
  String procStateDesc;
  String procMsg;
  String procResDesc;
  xml.XmlDocument xmlDoc;

  String eventTimeDate;

  Order(this.id, this.eventTime, this.partner, this.msgType, this.procEnv,
      this.procStateDesc, this.procMsg, this.procResDesc, [this.xmlDoc])
      : eventTimeDate = new DateFormat('yyyy-MM-dd').format(eventTime);

  factory Order.fromJson(Map<String, dynamic> map) => new Order(
        map['id'],
        DateTime.parse(map['eventTime']),
        map['partner'],
        map['msgType'],
        map['procEnv'],
        map['procStateDesc'],
        map['procMsg'],
        map['procResDesc'],
        map.containsKey('xml') ? xml.parse(map['xml']) : null,
      );
}
