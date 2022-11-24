// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:burger_api/app/entities/order_item.dart';
import 'package:burger_api/app/entities/user.dart';

class Order {
  final int id;
  final User user;
  final String? transactionId;
  final String? cpf;
  final String deliveryAddress;
  final String status;
  final List<OrderItem> items;
  Order({
    required this.id,
    required this.user,
    this.transactionId,
    this.cpf,
    required this.deliveryAddress,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'transactionId': transactionId,
      'cpf': cpf,
      'deliveryAddress': deliveryAddress,
      'status': status,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      deliveryAddress: map['deliveryAddress'] as String,
      status: map['status'] as String,
      items: List<OrderItem>.from(
        (map['items'] as List<int>).map<OrderItem>(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
