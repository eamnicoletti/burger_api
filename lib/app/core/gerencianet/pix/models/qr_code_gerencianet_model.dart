import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class QrCodeGerencianetModel {
  String image;
  String code;

  QrCodeGerencianetModel({
    required this.image,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'code': code,
    };
  }

  factory QrCodeGerencianetModel.fromMap(Map<String, dynamic> map) {
    return QrCodeGerencianetModel(
      image: map['image'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QrCodeGerencianetModel.fromJson(String source) =>
      QrCodeGerencianetModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
