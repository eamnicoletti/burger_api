import 'package:mysql1/mysql1.dart';
// import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:dotenv/dotenv.dart';

class Database {
  // carrega as configuracoes do BD no .env
  var env = DotEnv(includePlatformEnvironment: true)..load();

  Future<MySqlConnection> openConnection() async {
    return await MySqlConnection.connect(ConnectionSettings(
        host: env['DATABASE_HOST'] ?? env['databaseHost'] ?? '',
        port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort'] ?? '') ??
            3306,
        user: env['DATABASE_USER'] ?? env['databaseUser'],
        password: env['DATABASE_PASSWORD'] ?? env['databasePassword'],
        db: env['DATABASE_NAME'] ?? env['databaseName']));
  }
}
