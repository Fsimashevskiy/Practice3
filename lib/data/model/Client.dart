import 'package:flutter_auth/domain/entity/Client_entity.dart';

class IssuePoint extends IssuePointEntity {
  int? id;
  late String name;
  late String address;

  IssuePoint({required this.name, required this.address})
      : super(name: name, address: address);

  Map<String, dynamic> toMap() {
    return {'name': name, 'address': address};
  }

  factory IssuePoint.toFromMap(Map<String, dynamic> json) {
    return IssuePoint(name: json['name'], address: json['address']);
  }
}
