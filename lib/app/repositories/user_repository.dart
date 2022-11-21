import 'package:burger_api/app/core/database/database.dart';
import 'package:burger_api/app/core/exceptions/email_already_registered.dart';
import 'package:burger_api/app/core/exceptions/user_notfound_exception.dart';
import 'package:burger_api/app/core/helpers/cripty_helper.dart';
import 'package:burger_api/app/entities/user.dart';
import 'package:mysql1/mysql1.dart';
// import 'package:galileo_mysql/galileo_mysql.dart';

class UserRepository {
  // Login
  Future<User> login(String email, String password) async {
    MySqlConnection? conn;

    try {
      conn = await Database().openConnection();
      final result = await conn.query('''
        select * from usuario
        where email = ?
        and senha = ?
      ''', [email, CriptyHelper.generatedSha256Hash(password)]);

      if (result.isEmpty) {
        throw UserNotFoundException();
      }

      final userData = result.first;

      return User(
          id: userData['id'],
          name: userData['nome'],
          email: userData['email'],
          password: '');
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao realizar login');
    } finally {
      await conn?.close();
    }
  }

  // Cadastrar usuario
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      var isUserRegiser = await conn.query(
          'select * from usuario where email = ?', [user.email.toString()]);

      if (isUserRegiser.isEmpty) {
        await conn.query('insert into usuario values(?,?,?,?)', [
          null,
          user.name,
          user.email,
          CriptyHelper.generatedSha256Hash(user.password)
        ]);
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
