import 'package:intl/intl.dart';

class Order {
  int id;
  DateTime eventTime;
  String partner;
  String msgType;
  String procEnv;
  String procStateDesc;
  String procMsg;
  String procResDesc;

  Order(this.id, this.eventTime, this.partner, this.msgType, this.procEnv,
      this.procStateDesc, this.procMsg, this.procResDesc);

  factory Order.fromJson(Map<String, dynamic> map) => new Order(
        map['id'],
        DateTime.parse(map['eventTime']),
        map['partner'],
        map['msgType'],
        map['procEnv'],
        map['procStateDesc'],
        map['procMsg'],
        map['procResDesc'],
      );

  String get eventTimeDate => new DateFormat('yyyy-MM-dd').format(eventTime);

  String get eventTimeFull =>
      new DateFormat('yyyy-MM-dd HH:mm:ss').format(eventTime);
}
