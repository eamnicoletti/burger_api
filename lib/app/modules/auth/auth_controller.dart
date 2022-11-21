import 'dart:async';
import 'dart:convert';
import 'package:burger_api/app/core/exceptions/email_already_registered.dart';
import 'package:burger_api/app/core/exceptions/user_notfound_exception.dart';
import 'package:burger_api/app/entities/user.dart';
import 'package:burger_api/app/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  // Login
  @Route.post('/')
  Future<Response> login(Request request) async {
    final jsonRQ = jsonDecode(await request.readAsString());

    try {
      final user =
          await _userRepository.login(jsonRQ['email'], jsonRQ['password']);
      return Response.ok(user.toJson(), headers: {
        'content-type': 'application/json',
      });
    } on UserNotFoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  // Cadastrar Usuario
  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      await _userRepository.save(userRq);

      return Response(200, headers: {
        'content-type': 'application/json',
      });
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode(
            {'error': 'Email já cadastrado!'},
          ),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      print('printou e: $e');
      print('printou s: $s');
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
