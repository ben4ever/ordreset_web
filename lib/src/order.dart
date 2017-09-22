import 'package:intl/intl.dart';

class Order {
  int id;
  DateTime eventTime;
  String partner;
  String msgType;
  String procDesc;
  String procMsg;
  String errMsg;

  Order(this.id, this.eventTime, this.partner, this.msgType, this.procDesc,
      this.procMsg, this.errMsg);

  factory Order.fromJson(Map<String, dynamic> map) => new Order(
        map['id'],
        DateTime.parse(map['eventTime']),
        map['partner'],
        map['msgType'],
        map['procDesc'],
        map['procMsg'],
        map['errMsg'],
      );

  String get eventTimeDate => new DateFormat('yyyy-MM-dd').format(eventTime);

  String get eventTimeFull =>
      new DateFormat('yyyy-MM-dd HH:mm:ss').format(eventTime);
}
