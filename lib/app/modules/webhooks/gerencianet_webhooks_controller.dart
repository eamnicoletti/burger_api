import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:burger_api/app/core/gerencianet/pix/gerencianet_pix.dart';
import 'package:burger_api/app/modules/webhooks/view_models/gerencianet_callback_view_model.dart';
import 'package:burger_api/app/service/order_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'gerencianet_webhooks_controller.g.dart';

class GerencianetWebhooksController {
  final _orderService = OrderService();

  @Route.post('/webhook/register')
  Future<Response> register(Request request) async {
    await GerencianetPix().registerWebHook();
    return Response.ok(jsonEncode({}),
        headers: {'content-type': 'application/json'});
  }

  @Route.post('/webhook')
  Future<Response> webhookConfig(Request request) async {
    return Response(200, headers: {'content-type': 'application/json'});
  }

  @Route.post('/webhook/pix')
  Future<Response> webhookPaymentCallback(Request request) async {
    try {
      final callback =
          GerencianetCallbackViewModel.fromJson(await request.readAsString());

      await _orderService
          .confirmPayment(callback.pix.map((p) => p.transactionId));

      return Response.ok(jsonEncode({}),
          headers: {'content-type': 'application/json'});
    } catch (e, s) {
      log('Erro no Webhook Payment Callback', error: e, stackTrace: s);
      return Response.internalServerError();
    }
  }

  Router get router => _$GerencianetWebhooksControllerRouter(this);
}
