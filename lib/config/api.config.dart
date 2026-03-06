import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get username => dotenv.env['API_USERNAME'] ?? '';
  static String get password => dotenv.env['API_PASSWORD'] ?? '';

  // Para los números, necesitamos convertirlos de texto a entero
  static int get clientId =>
      int.tryParse(dotenv.env['API_CLIENT_ID'] ?? '0') ?? 0;
  static int get roleId => int.tryParse(dotenv.env['API_ROLE_ID'] ?? '0') ?? 0;
  static int get orgId => int.tryParse(dotenv.env['API_ORG_ID'] ?? '0') ?? 0;
  static int get warehouseId =>
      int.tryParse(dotenv.env['API_WAREHOUSE_ID'] ?? '0') ?? 0;

  static String get tableName => dotenv.env['API_TABLE_NAME'] ?? '';
}
