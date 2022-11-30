import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GerencianetPixViewModel {
  final String endToEndId;
  final String transactionId;
  final String pixKey;
  final String value;
  final String dateProcess;
  final String description;

  GerencianetPixViewModel({
    required this.endToEndId,
    required this.transactionId,
    required this.pixKey,
    required this.value,
    required this.dateProcess,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'endToEndId': endToEndId,
      'txid': transactionId,
      'chave': pixKey,
      'valor': value,
      'horario': dateProcess,
      'infoPagador': description,
    };
  }

  factory GerencianetPixViewModel.fromMap(Map<String, dynamic> map) {
    return GerencianetPixViewModel(
      endToEndId: map['endToEndId'] as String,
      transactionId: map['txid'] as String,
      pixKey: map['chave'] as String,
      value: map['valor'] as String,
      dateProcess: map['horario'] as String,
      description: map['infoPagador'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GerencianetPixViewModel.fromJson(String source) =>
      GerencianetPixViewModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
