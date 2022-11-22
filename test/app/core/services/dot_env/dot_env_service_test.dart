import 'package:burger_api/app/core/services/dot_env/dot_env_service.dart';
import 'package:test/test.dart';

void main() {
  test('dot env service ...', () async {
    final service = DotEnvService.instance;
    expect(service['databaseHost'], 'localhost');
  });
}
