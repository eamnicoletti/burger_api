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
}
