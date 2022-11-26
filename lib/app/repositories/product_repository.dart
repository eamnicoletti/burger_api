import 'dart:developer';

import 'package:burger_api/app/core/database/database.dart';
import 'package:burger_api/app/entities/product.dart';
import 'package:mysql1/mysql1.dart';

class ProductRepository {
  Future<List<Product>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await Database().openConnection();
      final result = await conn.query('select * from produto');

      return result
          .map((product) => Product(
                id: product['id'],
                name: product['nome'],
                description: (product['descricao'] as Blob?)?.toString() ?? '',
                price: product['preco'],
                image: (product['imagem'] as Blob?)?.toString() ?? '',
              ))
          .toList();
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }

  Future<Product> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result =
          await conn.query('select * from produto where id = ?', [id]);

      final mysqlData = result.first;

      return Product(
        id: mysqlData['id'],
        name: mysqlData['nome'],
        description: (mysqlData['descricao'] as Blob?)?.toString() ?? '',
        price: mysqlData['preco'],
        image: (mysqlData['imagem'] as Blob?)?.toString() ?? '',
      );
    } on MySqlException catch (e, s) {
      log('Erro ao retornar produto pelo Id', error: e, stackTrace: s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
