import 'dart:developer';

import 'package:burger_api/app/core/gerencianet/gerencianet_rest_client.dart';
import 'package:burger_api/app/core/gerencianet/pix/models/billing_gerencianet_model.dart';
import 'package:burger_api/app/core/gerencianet/pix/models/qr_code_gerencianet_model.dart';
import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart';

class GerencianetPix {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  Future<BillingGerencianetModel> generateBilling(
      double value, String? cpf, String? name, int orderId) async {
    try {
      final gerencianetRestClient = GerencianetRestClient();
      final billingData = {
        'calendario': {'expiracao': 3600},
        'devedor': {
          'cpf': cpf,
          'nome': name,
        },
        'valor': {'original': value.toStringAsFixed(2)},
        'chave': env['gerencianetChavePix'],
        'solicitacaoPagador': 'pedido de número $orderId no Burger Delivery',
        'infoAdicionais': [
          {'nome': 'orderId', 'valor': '$orderId'}
        ]
      };

      final billingResponse = await gerencianetRestClient.auth().post(
            '/v2/cob',
            data: billingData,
          );
      final billingResponseData = billingResponse.data;

      return BillingGerencianetModel(
          transactionId: billingResponseData['txid'],
          locationId: billingResponseData['loc']['id']);
    } on DioError catch (e, s) {
      log('Erro ao gerar cobranca PIX na API Gerencianet',
          error: e.response, stackTrace: s);
      rethrow;
    }
  }

  Future<QrCodeGerencianetModel> getQrCode(int locationId) async {
    try {
      final gerencianetPix = GerencianetRestClient();
      final qrResponse =
          await gerencianetPix.auth().get('/v2/loc/$locationId/qrcode');

      final qrCodeResponseData = qrResponse.data;

      return QrCodeGerencianetModel(
          image: qrCodeResponseData['imagemQrcode'],
          code: qrCodeResponseData['qrcode']);
    } on DioError catch (e, s) {
      log('Erro ao obter QRCode PIX na API Gerencianet',
          error: e.response, stackTrace: s);
      rethrow;
    }
  }

  Future<void> registerWebHook() async {
    final gerencianetRestClient = GerencianetRestClient();
    await gerencianetRestClient
        .auth()
        .put('/v2/webhook/${env['gerencianetChavePix']}', data: {
      "webhookUrl": env['gerencianetUrlWebHook'],
    });
  }
}
