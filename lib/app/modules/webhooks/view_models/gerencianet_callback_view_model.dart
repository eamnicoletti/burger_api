// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:burger_api/app/modules/webhooks/view_models/gerencianet_pix_view_model.dart';

class GerencianetCallbackViewModel {
  List<GerencianetPixViewModel> pix;

  GerencianetCallbackViewModel({
    required this.pix,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pix': pix.map((x) => x.toMap()).toList(),
    };
  }

  factory GerencianetCallbackViewModel.fromMap(Map<String, dynamic> map) {
    return GerencianetCallbackViewModel(
      pix: List<GerencianetPixViewModel>.from(
        map['pix']?.map(
              (x) => GerencianetPixViewModel.fromMap(x),
            ) ??
            const [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GerencianetCallbackViewModel.fromJson(String source) =>
      GerencianetCallbackViewModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
